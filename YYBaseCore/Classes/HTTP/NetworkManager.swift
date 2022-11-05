//
//  NetworkManager.swift
//  Core
//
//  Created by Chris on 2021/12/7.
//

import Foundation
import Alamofire

public enum ReachabilityStatus {
    /// 无网络
    case notReachable
    /// 未知网络
    case unknown
    /// Wifi网络
    case ethernetOrWiFi
    /// 蜂窝数据
    case wWan
}

open class NetworkManager {

    private static let shared = { () -> NetworkManager in
        let manager = NetworkManager()
        return manager
    }()
    
    private let manager = NetworkReachabilityManager.init()
     
    public static func netWorkReachability(reachabilityStatus: @escaping (ReachabilityStatus) -> Void) {
        
   
    }
    
    public static func stopReachability() {
        shared.manager?.stopListening()
    }
}
