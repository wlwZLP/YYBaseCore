import Foundation
import SwiftyJSON

public protocol BMWebSocketMessagePredicate {
    associatedtype Message: BMWebSocketMessage
    /// Can handle the message received from the web socket server.
    func canHandle(_ message: Message) -> Bool
}

public protocol BMWebSocketEndpoint: BMWebSocketMessagePredicate, Hashable {
    associatedtype Value
    /// The message to subscribe message for the endpoint.
    var subscribeMessage: String? { get }
    /// The message to unsubscribe message for the endpoint.
    var unsubscribeMessage: String? { get }
    /// Extract the value from message received from web socket server.
    func extractValue(from message: Message) throws -> Value
}

/// A type of the message received from a certain web socket server.
public protocol BMWebSocketMessage {
    init(webSocketMessage: String) throws
}

struct AnyBMWebSocketEndpoint<Message: BMWebSocketMessage>: Hashable, BMWebSocketMessagePredicate {
    private var base: AnyHashable
    private var _subscribeMessage: () -> String?
    private var _unsubscribeMessage: () -> String?
    private var _canHandle: (Message) -> Bool
    private var _extractValue: (Message) throws -> Any
    var subscribeMessage: String? { _subscribeMessage() }
    var unsubscribeMessage: String? { _unsubscribeMessage() }

    init<P: BMWebSocketEndpoint>(_ endpoint: P) where P.Message == Message {
        base = endpoint
        _subscribeMessage = { endpoint.subscribeMessage }
        _unsubscribeMessage = { endpoint.unsubscribeMessage }
        _canHandle = { endpoint.canHandle($0) }
        _extractValue = { try endpoint.extractValue(from: $0) }
    }

    func canHandle(_ message: Message) -> Bool {
        _canHandle(message)
    }

    func extractValue(from message: Message) throws -> Any {
        try _extractValue(message)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(base)
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.base == rhs.base
    }
}

extension BMWebSocketEndpoint {
    func typeErased() -> AnyBMWebSocketEndpoint<Message> {
        .init(self)
    }
}

extension JSON: BMWebSocketMessage {
    public init(webSocketMessage: String) throws {
        self = JSON(parseJSON: webSocketMessage)
    }
}
