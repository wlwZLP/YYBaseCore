//
//  DispatchQueueExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /// App生命周期内不论调用几次，都只执行一次代码块
    /// - Parameters:
    ///   - token: 代码块执行一次的唯一识别标识
    ///   - closure: 代码块
    class func once(token: String, closure: () -> Void) {
        objc_sync_enter(self)
        
        defer {
            objc_sync_exit(self)
        }
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        
        closure()
    }
}
