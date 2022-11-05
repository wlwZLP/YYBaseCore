//
//  Keychains.swift
//  Core
//
//  Created by Chris on 2022/3/22.
//

import Foundation
import KeychainAccess

/// 钥匙串工具
public struct Keychains {
    /// 单例
    public static let shared = Keychains()
    /// 实际钥匙串存取对象
    private var keychain = Keychain(service: AppInfo.bundleId)
    
    private init() {}
    
    /// 保存数据到钥匙串
    /// - Parameters:
    ///   - value: 需要保存的数据
    ///   - key: 需要保存的数据对应的键
    /// - Throws: 错误
    public func set(value: String, key: String) throws {
        try keychain.set(value, key: key)
    }
    
    /// 从钥匙串获取数据
    /// - Parameter key: 需要获取的数据对应的键
    /// - Throws: error
    /// - Returns: 获取的数据
    public func get(key: String) throws -> String? {
        try keychain.get(key)
    }
    
}

