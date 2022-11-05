import Alamofire
import Combine

class NetworkStatus {
    public static let shared = NetworkStatus()
    private var queue = DispatchQueue.global()
    private let reachability = NetworkReachabilityManager(host: "8.8.8.8")
    private(set) var isReachable: CurrentValueSubject<Bool, Never> = .init(true)

    private init() {
        reachability?.startListening { [weak self] in
            self?.isReachable.value = $0 != .unknown && $0 != .notReachable
            YYLogger.default.info("Status: \($0)", category: "NetworkStatus")
        }
    }
}
