//
//  UIColorExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/9.
//

import Foundation

public extension UIColor {
    /// 以一个16进制字符串和一个透明度值创建一个颜色
    ///
    /// - Parameters:
    ///   - hex: 一个16进制字符串 (例如: "EDE7F6", "0xEDE7F6", "#EDE7F6", "#0ff", "0xF0F")
    ///   - alpha: 一个可选的透明度值 (默认是 1)
    convenience init?(_ hex: String, alpha: CGFloat = 1.0) {
        var string = ""
        if hex.lowercased().hasPrefix("0x") {
            string = hex.replacingOccurrences(of: "0x", with: "")
        } else if hex.hasPrefix("#") {
            string = hex.replacingOccurrences(of: "#", with: "")
        } else {
            string = hex
        }
        if string.count == 3 {
            var str = ""
            string.forEach { str.append(String(repeating: String($0), count: 2)) }
            string = str
        }
        guard let hexValue = Int(string, radix: 16) else { return nil }
        let red = (hexValue >> 16) & 0xff
        let green = (hexValue >> 8) & 0xff
        let blue = hexValue & 0xff
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    /// 通过RGBA值创建一个颜色
    /// - Parameters:
    ///   - red: 红色值
    ///   - green: 绿色值
    ///   - blue: 蓝色值
    ///   - alpha: 透明度值（默认1.0）
    convenience init(red: Int, green: Int, blue: Int, _ alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0,
                  green: CGFloat(green) / 255.0,
                  blue: CGFloat(blue) / 255.0,
                  alpha: alpha)
    }
    
    /// 生成一个带透明度的随机颜色
    ///
    /// - Parameter alpha: 透明度值
    /// - Returns: 随机颜色
    static func random(alpha: CGFloat = 1.0) -> UIColor {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}
