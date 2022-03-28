//
//  DataExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public extension Data {
    
    /// Data 值转 UTF8 格式的字符串
    var utf8String: String? {
        return String(data: self, encoding: .utf8)
    }
    
}
