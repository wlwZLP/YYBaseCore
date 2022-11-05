//
//  FilePathExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/9.
//

import Foundation

/// 文件路径协议
public protocol FilePath {
    
    /// 路径URL
    var urlPath: URL { get }
    
    /// 路径字符串
    var stringPath: String { get }
    
}

public extension FilePath {
    
    /// 文件是否存在
    var isFileExists: Bool {
        return FileManager.default.fileExists(atPath: stringPath)
    }
    
    /// 是否是目录
    var isDirectory: Bool {
        var isDir: ObjCBool = false
        let isExists: Bool = FileManager.default.fileExists(atPath: stringPath, isDirectory: &isDir)
        return isExists && isDir.boolValue
    }
    
}

extension String: FilePath {

    /// 获取路径URL实例
    public var urlPath: URL {
        return URL(fileURLWithPath: self)
    }
    
    /// 获取路径字符串（即它本身）
    public var stringPath: String {
        return self
    }
    
    /// 路径拼接并返回新的路径字符串
    /// - Parameter pathComponent: 需要拼接的子路径字符串
    /// - Returns: 新的路径字符串
    public func appendingPathComponent(_ pathComponent: String) -> String {
        return self.urlPath.appendingPathComponent(pathComponent).stringPath
    }
}

extension URL: FilePath {
    
    /// 获取路径URL实例（即它本身）
    public var urlPath: URL {
        return self
    }
    
    /// 获取路径字符串
    public var stringPath: String {
        return self.path
    }
    
}
