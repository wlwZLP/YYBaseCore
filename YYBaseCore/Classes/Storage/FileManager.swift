//
//  FileManagerExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/9.
//

import Foundation

// MARK: - 常用目录
public extension FileManager {
    
    /// documents文件夹路径
    /// - Parameter pathComponent: 拼接路径
    /// - Returns: 路径URL
    func documentsPath(with pathComponent: String = "") -> URL? {
        guard let url = urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(pathComponent)
    }
    
    /// library文件夹路径
    /// - Parameter pathComponent: 拼接路径
    /// - Returns: 路径URL
    func libraryPath(with pathComponent: String = "") -> URL? {
        guard let url = urls(for: .libraryDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(pathComponent)
    }
    
    /// cache文件夹路径
    /// - Parameter pathComponent: 拼接路径
    /// - Returns: 路径URL
    func cachePath(with pathComponent: String = "") -> URL? {
        guard let url = urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(pathComponent)
    }
    
    /// temporary文件夹路径
    /// - Parameter pathComponent: 拼接路径
    /// - Returns: 路径URL
    func temporaryPath(with pathComponent: String = "") -> URL {
        return NSTemporaryDirectory().appendingPathComponent(pathComponent).urlPath
    }
    
    /// applicationSupport文件夹路径
    /// - Parameter file: 拼接路径
    /// - Returns: 路径URL
    func applicationSupportPath(with pathComponent: String = "") -> URL? {
        guard let url = urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            return nil
        }
        if !fileExists(atPath: url.absoluteString, isDirectory: nil) {
            do {
                try createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        return url.appendingPathComponent(pathComponent)
    }
    
}

//MARK: - 文件操作（读、写、删除、移动等等）
public extension FileManager {
    
    /// 新建文件夹
    /// - Parameter path: 文件夹路径
    /// - Returns: 是否创建成功
    @discardableResult
    func createDirectory(_ path: FilePath) -> Bool {
        let isExisted = path.isDirectory
        if !isExisted {
            do {
                try createDirectory(at: path.urlPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return false
            }
        }
        return true
    }
    
    /// 删除文件
    /// - Parameters:
    ///   - file: 文件名
    ///   - path: 文件目录
    /// - Returns: 是否成功
    @discardableResult
    func delete(file: String, from path: FilePath) -> Bool {
        if !file.isEmpty, fileExists(atPath: path.stringPath.appendingPathComponent(file)) {
            do {
                try removeItem(atPath: path.stringPath.appendingPathComponent(file))
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    /// 保存文本
    /// - Parameters:
    ///   - content: 文本内容
    ///   - path: 文件目录
    ///   - file: 文件名
    /// - Returns: 是否成功
    @discardableResult
    func save(_ content: String, to path: FilePath, file: String) -> Bool {
        createDirectory(path)
        do {
            try content.write(toFile: path.stringPath.appendingPathComponent(file), atomically: true, encoding: .utf8)
        } catch {
            return false
        }
        return true
    }
    
    /// 读取文本
    /// - Parameters:
    ///   - file: 文件名
    ///   - path: 文件目录
    /// - Returns: 文本内容
    func read(file: String, from path: FilePath) -> String? {
        return try? String(contentsOfFile: path.stringPath.appendingPathComponent(file), encoding: .utf8)
    }
    
    /// 移动文件
    /// - Parameters:
    ///   - file: 文件名
    ///   - origin: 原目录
    ///   - destination: 目标目录
    /// - Returns: 是否成功
    @discardableResult
    func move(file: String, from origin: FilePath, to destination: FilePath) -> Bool {
        let paths = check(file: file, origin: origin, destination: destination)
        if paths.fileExist {
            do {
                try moveItem(atPath: paths.origin, toPath: paths.destination)
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
    /// 复制文件
    /// - Parameters:
    ///   - file: 文件名
    ///   - origin: 原目录
    ///   - destination: 目标目录
    /// - Returns: 是否成功
    @discardableResult
    func copy(file: String, from origin: FilePath, to destination: FilePath) -> Bool {
        let paths = check(file: file, origin: origin, destination: destination)
        if paths.fileExist {
            do {
                try copyItem(atPath: paths.origin, toPath: paths.destination)
                return true
            } catch {
                return false
            }
        } else {
            return false
        }
    }
    
    /// 路径检查
    /// - Parameters:
    ///   - file: 文件
    ///   - origin: 原目录
    ///   - destination: 目标目录
    /// - Returns: （原路径，目标路径，文件是否存在）
    private func check(file: String, origin: FilePath, destination: FilePath) -> (origin: String, destination: String, fileExist: Bool) {
        
        let finalOriginPath = origin.stringPath.appendingPathComponent(file)
        let finalDestinationPath = destination.stringPath.appendingPathComponent(file)
        
        guard !fileExists(atPath: finalOriginPath) else {
            return (finalOriginPath, finalDestinationPath, true)
        }
        
        return (finalOriginPath, finalDestinationPath, false)
    }
    
    /// 重命名
    /// - Parameters:
    ///   - file: 原文件名
    ///   - origin: 目录
    ///   - newName: 新文件名
    /// - Returns: 是否成功
    @discardableResult
    func rename(file: String, in path: FilePath, to newName: String) -> Bool {
        let finalOriginPath = path.stringPath.appendingPathComponent(file)
        guard fileExists(atPath: finalOriginPath) else {
            return false
        }
        let destinationPath: String = finalOriginPath.replacingOccurrences(of: file, with: newName)
        do {
            try copyItem(atPath: finalOriginPath, toPath: destinationPath)
            try removeItem(atPath: finalOriginPath)
            return true
        } catch {
            return false
        }
    }
    
}


//MARK: - 文件信息 (暂时没有用到)
/// 文件信息
public struct FileInfo {
    
    /// 文件名
    public var fileName: String?
    /// 目录
    public var path: String?
    /// 全路径
    public var fullPath: String?
    /// 是否是文件夹
    public var isDirectory: Bool?
    /// 文件信息
    public var attributes: [FileAttributeKey : Any]?
    
    /// 创建时间
    public var createTime: Date? {
        attributes?[.creationDate] as? Date
    }
    
    /// 更新时间
    public var updateTime: Date? {
        attributes?[.modificationDate] as? Date
    }
    
    /// 文件（夹）大小，单位Byte
    public var size: Int? {
        guard isDirectory ?? false, let subpaths = subpaths else {
            return attributes?[.size] as? Int
        }
        return subpaths.reduce(0) { result, subpath -> Int in
            guard let path = fullPath?.appendingPathComponent(subpath),
                  let fileAttributes = try? FileManager.default.attributesOfItem(atPath: path),
                  let fileSize = fileAttributes[.size] as? Int else {
                return result
            }
            return  result + fileSize
        }
    }
    
    /// 当前文件夹下所有文件、文件夹
    public var contents: [String]? {
        guard isDirectory ?? false, let fullPath = fullPath else {
            return nil
        }
        let paths = try? FileManager.default.contentsOfDirectory(atPath: fullPath)
        return paths
    }
    
    /// 深遍历文件夹下所有文件、文件夹
    public var subpaths: [String]? {
        guard isDirectory ?? false, let fullPath = fullPath else {
            return nil
        }
        let paths = try? FileManager.default.subpathsOfDirectory(atPath: fullPath)
        return paths
    }
    
}
