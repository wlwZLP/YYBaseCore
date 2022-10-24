//
//  BundleExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public extension Bundle {
    
    /// 获取png图片
    /// - Parameters:
    ///   - imageName: 图片名称
    /// - Returns: 图片
    func pngImage(with imageName: String) -> UIImage? {
        self.image(with: imageName, suffix: "png")
    }
    
    /// 获取jpeg图片
    /// - Parameters:
    ///   - imageName: 图片名称
    /// - Returns: 图片
    func jpegImage(with imageName: String) -> UIImage? {
        self.image(with: imageName, suffix: "jpeg")
    }
    
    /// 获取指定的文件路径
    /// - Parameters:
    ///   - fileName: 文件名称
    ///   - fileSuffix: 文件后缀
    /// - Returns: 文件路径
    func filePath(with fileName: String?, fileSuffix: String) -> String? {
        guard let filePath = self.path(forResource: fileName, ofType: fileSuffix) else {
            return nil
        }
        return filePath
    }
    
    /// 从指定bundle获取图片
    /// - Parameters:
    ///   - imageName: 图片名称
    ///   - suffix: 图片后缀 ( png, jpeg )
    /// - Returns: 图片
    func image(with imageName: String, suffix: String) -> UIImage? {
        guard let filePath = self.path(forResource: imageName, ofType: suffix) else {
            return nil
        }
        return UIImage(contentsOfFile: filePath)
    }
    
    /// 获取指定bundle
    /// - Parameter bundleClass: bundle 中任意 class 的类型（如果想获取 main bundle，什么也不传）
    /// - Returns: bundle实例
    static func bundle(_ bundleClass: AnyClass = Bundle.self) -> Bundle? {
        guard bundleClass != Bundle.self else {
            return Bundle.main
        }
        
        return Bundle(for: bundleClass)
    }
    
    /// 获取指定资源文件的bundle
    /// - Parameter bundleName: 资源文件所在的bundle
    /// - Returns: 资源文件bundle
    func resourcesBundle(with bundleName: String) -> Bundle? {
        guard let bundlePath = self.path(forResource: bundleName, ofType: "bundle") else {
            return nil
        }
        
        return Bundle(path: bundlePath)
    }
    
}

