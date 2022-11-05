import Foundation

public final class BMWebSocketConnection: NSObject, @unchecked Sendable {
    public let url: URL
    private var task: URLSessionWebSocketTask?
    private var timer: Timer?
    private var messageTask: Task<Void, Never>?
    private lazy var session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    public var onReceive: BMDelegate<String, Void> = .init()
    public var onConnect: BMDelegate<Void, Void> = .init()
    public var onComplete: BMDelegate<Error?, Void> = .init()
    public private(set) var isConnected: Bool = false
    /// 保持心跳的ping事件
    private static var pingMessage: String = {
        let data = try! JSONEncoder().encode(["subscribe": "ping"])
        return String(data: data, encoding: .utf8)!
    }()

    public init(url: URL) {
        self.url = url
        super.init()
    }

    // MARK: - Public Methods

    public func connect() {
        guard !isConnected else { return }
        YYLogger.default.info("Try to establish connection with \(url.absoluteString)", category: "BMWebSocketConnection")
        isConnected = true
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        task = session.webSocketTask(with: request)
        task?.resume()
    }

    public func disconnect() {
        YYLogger.default.info("Destroy web socket connection with \(url.absoluteString)", category: "BMWebSocketConnection")
        _disconnect()
        onComplete(nil)
    }

    public func sendMessage(_ message: String) async throws {
        try await task?.send(.string(message))
    }

    // MARK: - Private Methods

    private func receiveMessages() {
        messageTask = Task.detached { [weak self] in
            do {
                while true {
                    guard let task = self?.task else { break }
                    let message = try await task.receive().absoluteText
                    self?.onReceive(message)
                }
            } catch {
                YYLogger.default.error("Failed to receive message, error: \(error)", category: "BMWebSocketConnection")
            }
        }
    }

    private func connectionDidFailed(with error: Error) {
        _disconnect()
        onComplete(error)
    }

    private func _disconnect() {
        isConnected = false
        invalidatePingTimer()
        messageTask?.cancel()
        messageTask = nil
        task?.cancel(with: .goingAway, reason: nil)
        task = nil
    }

    // MARK: Ping

    private func schedulePingTimer() {
        invalidatePingTimer()
        timer = Timer(timeInterval: 5, repeats: true) { [weak self] _ in
            self?.sendPing()
        }
        RunLoop.main.add(timer!, forMode: .common)
    }

    private func invalidatePingTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func sendPing() {
        Task.detached {
            do {
                try await self.task?.send(.string(Self.pingMessage))
            } catch {
                YYLogger.default.debug("Failed to send ping, error: \(error)", category: "BMWebSocketConnection")
            }
        }
    }

    deinit {
        disconnect()
    }
}

// MARK: - URLSessionWebSocketDelegate

extension BMWebSocketConnection: URLSessionWebSocketDelegate {
    public func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        YYLogger.default.debug("URLSession did connect", category: "BMWebSocketConnection")
        isConnected = true
        onConnect(())
        receiveMessages()
        schedulePingTimer()
    }

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        YYLogger.default.debug("URLSession did finish \(error?.localizedDescription ?? "nil")", category: "BMWebSocketConnection")
        guard let error = error else { return }
        connectionDidFailed(with: error)
    }
}

@available(iOS 13.0, *)
private extension URLSessionWebSocketTask.Message {
    var absoluteText: String {
        switch self {
        case let .data(data):
            guard let data = try? (data as NSData).decompressed(using: .zlib),
                  let text = String(data: data as Data, encoding: .utf8)
            else {
                return ""
            }
            return text
        case let .string(string):
            return string
        @unknown default:
            return ""
        }
    }
}
