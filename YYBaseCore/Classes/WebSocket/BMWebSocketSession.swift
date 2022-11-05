import Combine
import UIKit

/// 因为沙雕 Apple 把 UIApplication 的这几个方法没有标注为 `nonisolated`，导致在其他的 actor 无法同步访问
private extension Notification.Name {
    static var applicationWillEnterForeground: Self {
        UIApplication.willEnterForegroundNotification
    }

    static var applicationDidEnterBackground: Self {
        UIApplication.didEnterBackgroundNotification
    }
}

/// - [x] Maintaining the web socket connection
/// - [x] Dispatch messages
/// - [x] Observe network connectivity and reconnect if needed
public final actor BMWebSocketSession<Message: BMWebSocketMessage> {
    public let url: URL
    private var connection: BMWebSocketConnection
    private var subscribersByID: [AnyBMWebSocketEndpoint<Message>: [UUID: AnySubscriber<Message>]] = [:]
    private var isConnecting: Bool = false
    /// 是否手动关闭
    private var isTerminated: Bool = true
    private var subscriptions: Set<AnyCancellable> = []
    private var notifications: Set<AnyCancellable> = []

    private let threshold: Int = 3
    private var failedTimes: Int = 0 {
        didSet { if failedTimes >= threshold {
            isCriticalErrorOccurred = true
            criticalErrorOccurred()
        }}
    }

    /// If failed retry to connect for more than `threshold` times. we treat that a critical retry error.
    /// The we will wait for a period of time instead of trying to reconnect instantly.
    private var criticalRetryInterval: TimeInterval = 10
    private var isCriticalErrorOccurred: Bool = false

    public init(url: URL) {
        self.url = url
        connection = BMWebSocketConnection(url: url)
        NotificationCenter.default
            .publisher(for: .applicationWillEnterForeground)
            .sink { [unowned self] _ in
                reconnectIfNeeded()
            }.store(in: &notifications)
        NotificationCenter.default
            .publisher(for: .applicationDidEnterBackground)
            .sink { [unowned self] _ in
                _disconnect(terminated: false)
            }.store(in: &notifications)
    }

    public nonisolated func connect() {
        Task.detached {
            await self._connect()
        }
    }

    private func _connect() {
        isConnecting = true
        isTerminated = false
        connection.connect()
        connection.onComplete.delegate(on: self) { target, input in
            Task.detached { await target.onComplete(error: input) }
        }

        connection.onReceive.delegate(on: self) { target, input in
            Task.detached { await target.onReceive(message: input) }
        }

        connection.onConnect.delegate(on: self) { target, _ in
            Task.detached { await target.onConnect() }
        }

        for endpoint in subscribersByID.keys {
            guard let message = endpoint.subscribeMessage else { continue }
            Task { try await connection.sendMessage(message) }
        }
        isConnecting = false

        NetworkStatus.shared.isReachable.sink { [unowned self] in
            if $0 { reconnectIfNeeded() }
        }.store(in: &subscriptions)
    }

    public nonisolated func disconnect() {
        Task.detached {
            await self._disconnect()
        }
    }

    deinit { _disconnect() }

    private func _disconnect(terminated: Bool = true) {
        isTerminated = terminated || isTerminated
        isConnecting = false
        connection.disconnect()
        subscriptions = []
    }

    private func reconnectIfNeeded() {
        YYLogger.default.info("Reconnected if needed, isConnected: \(connection.isConnected), isConnecting: \(isConnecting), terminated: \(isTerminated), criticalError: \(isCriticalErrorOccurred)", category: "BMWebSocketSession")
        guard !isCriticalErrorOccurred else { return }
        guard !connection.isConnected, !isConnecting, !isTerminated else { return }
        YYLogger.default.info("Reconnected", category: "BMWebSocketSession")
        isConnecting = true
        connect()
    }

    private func onReceive(message: String) {
        Task.detached { [weak self] in
            await self?.handleMessage(message: message)
        }
    }

    private func onConnect() {
        YYLogger.default.info("WebSocket connected to the server.", category: "BMWebSocketSession" )
        failedTimes = 0
        isCriticalErrorOccurred = false
    }

    private func onComplete(error: Error?) {
        if let error = error {
            YYLogger.default.error("Did failed with error: \(error)", category: "BMWebSocketSession")
            if NetworkStatus.shared.isReachable.value {
                failedTimes += 1
                reconnectIfNeeded()
            }
        } else {
            YYLogger.default.info("Complete", category: "BMWebSocketSession")
        }
    }

    private nonisolated func handleMessage(message: String) async {
        do {
            let message = try Message(webSocketMessage: message)
            guard let endpoint = await retrieveEndpoint(for: message),
                  let subscribers = await subscribersByID[endpoint]
            else { return }
            let value = try endpoint.extractValue(from: message)
            subscribers.forEach { $0.value(value) }
        } catch {
            YYLogger.default.error("Failed to parse message, error: \(error)", category: "BMWebSocketSession")
        }
    }

    private func criticalErrorOccurred() {
        YYLogger.default.error("Critical error occurred. The WebSocket will try to reconnect after a period of time.", category: "BMWebSocketSession")
        Timer.publish(every: criticalRetryInterval, on: .main, in: .common)
            .autoconnect()
            .first()
            .sink { [unowned self] _ in
                isCriticalErrorOccurred = false
                reconnectIfNeeded()
            }.store(in: &subscriptions)
    }
}

extension BMWebSocketSession {
    private func retrieveEndpoint(for message: Message) -> AnyBMWebSocketEndpoint<Message>? {
        subscribersByID.keys.first { $0.canHandle(message) }
    }
}

public extension BMWebSocketSession {
    func subscribe<P: BMWebSocketEndpoint>(_ endpoint: P, onReceive: @escaping (P.Value) -> Void) -> AnyCancellable where P.Message == Message {
        let subscriber = AnySubscriber<Message>(P.self, onReceive: onReceive)
        let id = subscriber.id
        let endpoint = endpoint.typeErased()
        var subscribers = subscribersByID[endpoint] ?? [:]
        if subscribers.isEmpty, let message = endpoint.subscribeMessage {
            Task {
                do {
                    try await self.connection.sendMessage(message)
                } catch {
                    YYLogger.default.error("Failed to subscribe \(endpoint), \(id) Error: \(error)", category: "BMWebSocketSession")
                }
            }
        }
        subscribers[id] = subscriber
        subscribersByID[endpoint] = subscribers
        return AnyCancellable {
            Task { [weak self] in
                await self?.unsubscribe(endpoint: endpoint, subscribeID: id)
            }
        }
    }

    private func unsubscribe(endpoint: AnyBMWebSocketEndpoint<Message>, subscribeID: UUID) async {
        guard var subscribers = subscribersByID[endpoint] else { return }
        subscribers[subscribeID] = nil
        subscribersByID[endpoint] = subscribers
        guard subscribers.isEmpty, let message = endpoint.unsubscribeMessage else { return }
        subscribersByID[endpoint] = nil
        do {
            try await connection.sendMessage(message)
        } catch {
            YYLogger.default.error("Failed to unsubscribe \(endpoint), \(subscribeID) Error: \(error)", category: "BMWebSocketSession")
        }
    }

    func stream<P: BMWebSocketEndpoint>(_ endpoint: P) -> AsyncStream<P.Value> where P.Message == Message {
        AsyncStream(P.Value.self, bufferingPolicy: .unbounded) { continuation in
            let cancellable = self.subscribe(endpoint) {
                continuation.yield($0)
            }
            continuation.onTermination = { _ in
                cancellable.cancel()
            }
        }
    }

    /// 链接通道订阅方式
    nonisolated func publisher<P: BMWebSocketEndpoint>(_ endpoint: P) -> BMWebSocketPublisher<P> where P.Message == Message {
        .init(endpoint: endpoint, session: self)
    }
}
