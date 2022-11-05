import Foundation

struct AnySubscriber<Message: BMWebSocketMessage>: @unchecked Sendable {
    let id = UUID()
    private let _onReceive: (Any) -> Void

    init<P: BMWebSocketEndpoint>(_ type: P.Type, onReceive: @escaping (P.Value) -> Void) {
        _onReceive = {
            onReceive($0 as! P.Value)
        }
    }

    func callAsFunction(_ value: Any) {
        _onReceive(value)
    }
}
