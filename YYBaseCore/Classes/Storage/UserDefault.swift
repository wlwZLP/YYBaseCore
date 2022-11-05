//
//  Storage.swift
//  Core
//
//  Created by Chris on 2022/3/22.
//

import Foundation

public enum ObjectSavableError: String {
    case unableToEncode = "无法将对象编码为data类型"
    case unableToDecode = "无法将对象解码为指定类型"
    case noValue = "无法通过指定Key查找到数据"
}

public protocol ObjectSavable {
    
    /// 存储指定的对象关联指定的key值
    /// 存储的对象必须遵循 Encodable 协议
    func setObject<Object>(_ object: Object, forKey key: String) where Object: Encodable
    
    /// 通过指定的Key和类型，取出该类型的对象
    /// - Returns: 返回指定类型的对象实例
    func getObject<Object>(forKey key: String, castTo type: Object.Type) -> Object? where Object: Decodable
}



extension UserDefaults: ObjectSavable {
    
    /// 存储指定的对象关联指定的key值
    /// 存储的对象必须遵循 Encodable 协议
    public func setObject<Object>(_ object: Object, forKey key: String) where Object : Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: key)
        } catch {
            print(ObjectSavableError.unableToEncode.rawValue)
        }
    }
    
    /// 通过指定的Key和类型，取出该类型的对象
    /// - Returns: 返回指定类型的对象实例
    public func getObject<Object>(forKey key: String, castTo type: Object.Type) -> Object? where Object : Decodable {
        guard let data = data(forKey: key) else {
            print(ObjectSavableError.noValue.rawValue)
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print(ObjectSavableError.unableToDecode.rawValue)
            return nil
        }
    }
    
}


