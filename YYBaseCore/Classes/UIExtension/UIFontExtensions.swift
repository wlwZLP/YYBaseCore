//
//  UIFontExtensions.swift
//  Core
//
//  Created by Chris on 2021/9/27.
//

import Foundation

public extension UIFont {
    

    /// pingFangSCMedium
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func pingFangSCRegular(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Regular", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    /// pingFangSCMedium
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func pingFangSCMedium(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Medium", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    /// pingFangSCSemiBold
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func pingFangSCSemiBold(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-SemiBold", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }

    /// pingFangSCLight
    /// - Parameter size: 字体大小
    /// - Returns: 字体
    static func pingFangSCLight(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: "PingFangSC-Light", size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
}
