//
//  URLExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/29.
//

import Foundation

extension Dictionary {
    
    /// 通过指定key值，获取String类型的value
    /// - Parameters:
    ///   - key: 指定的key
    ///   - def: 获取不到，或者转换失败时返回的值（默认为空字符串）
    /// - Returns: String类型的value
    public func getString(forKey key: Key, defaultValue def: String = "") -> String {
        if let str = self[key] as? String {
            return str
        }
        return def
    }
    
    /// 通过指定key值，获取Float类型的value
    /// - Parameters:
    ///   - key: 指定的key
    ///   - def: 获取不到，或者转换失败时返回的值（默认为0）
    /// - Returns: Float类型的value
    public func getFloat(forKey key: Key, defaultValue def: Float = 0.0) -> Float {
        if let num = self[key] as? Float {
            return num
        } else if let str = self[key] as? String {
            if let val = Float(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Float(truncating: num)
        }
        return def
    }
    
    /// 通过指定key值，获取Double类型的value
    /// - Parameters:
    ///   - key: 指定的key
    ///   - def: 获取不到，或者转换失败时返回的值（默认为0）
    /// - Returns: Double类型的value
    public func getDouble(forKey key: Key, defaultValue def: Double = 0.0) -> Double {
        if let num = self[key] as? Double {
            return num
        } else if let str = self[key] as? String {
            if let val = Double(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Double(truncating: num)
        }
        return def
    }
    
    /// 通过指定key值，获取Int类型的value
    /// - Parameters:
    ///   - key: 指定的key
    ///   - def: 获取不到，或者转换失败时返回的值（默认为0）
    /// - Returns: Int类型的value
    public func getInt(forKey key: Key, defaultValue def: Int = 0) -> Int {
        if let num = self[key] as? Int {
            return num
        } else if let str = self[key] as? String {
            if let val = Int(str) {
                return val
            }
        } else if let num = self[key] as? NSNumber {
            return Int(truncating: num)
        }
        return def
    }
    
    /// 通过指定key值，获取Bool类型的value
    /// - Parameters:
    ///   - key: 指定的key
    ///   - def: 获取不到，或者转换失败时返回的值（默认为false）
    /// - Returns: Bool类型的value
    public func getBool(forKey key: Key, defaultValue def: Bool = false) -> Bool {
        if let val = self[key] as? Bool {
            return val
        } else if let num = self[key] as? NSNumber {
            if num == 0 {
                return false
            } else if num == 1 {
                return true
            }
        } else if let str = self[key] as? String {
            if str.lowercased() == "true" || str.lowercased() == "yes" {
                return true
            } else if str.lowercased() == "false" || str.lowercased() == "no" {
                return false
            }
        }
        return def
    }
}

