//
//  Publishers.swift
//  BMWebSocket
//
//  Created by Octree on 2022/8/8.
//

import Combine
import Foundation

public final class BMWebSocketPublisher<Endpoint: BMWebSocketEndpoint>: Publisher {
    public typealias Output = Endpoint.Value
    public typealias Failure = Never
    private var endpoint: Endpoint
    private weak var session: BMWebSocketSession<Endpoint.Message>?

    init(endpoint: Endpoint, session: BMWebSocketSession<Endpoint.Message>) {
        self.endpoint = endpoint
        self.session = session
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Endpoint.Value == S.Input {
        subscriber.receive(subscription: BMWebSocketSubscription(target: subscriber, endpoint: endpoint, session: session))
    }
}

private final class BMWebSocketSubscription<Target: Subscriber, Endpoint: BMWebSocketEndpoint> where Target.Input == Endpoint.Value {
    // MARK: - Properties
    private var cancellable: AnyCancellable?
    private var target: Target?

    // MARK: - Life Cycle
    init(target: Target, endpoint: Endpoint, session: BMWebSocketSession<Endpoint.Message>?) {
        self.target = target
        Task.detached {
            self.cancellable = await session?.subscribe(endpoint) { [weak self] in
                _ = self?.target?.receive($0)
            }
        }
    }

    // MARK: - Public Methods

    private func unsubscribe() {
        cancellable?.cancel()
    }
}

extension BMWebSocketSubscription: Subscription {
    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        unsubscribe()
        target = nil
    }
}
