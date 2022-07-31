//
//  StringExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/9.
//

import Foundation
import CommonCrypto

/// 获取随机字符串规则
/// - digitsOnly: 纯数字
/// - lettersOnly: 纯字母
/// - `default`: 数字加字母
public enum BMRandomStringType {
    /// 纯数字
    case digitsOnly
    /// 纯字母
    case lettersOnly
    /// 数字加字母
    case `default`
}

public extension String {
    
    /// String 值转 Bool
    var bool: Bool? {
        let selfLowercased = trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch selfLowercased {
        case "true", "yes", "1":
            return true
        case "false", "no", "0":
            return false
        default:
            return nil
        }
    }
    
    /// String 值转 Int
    var int: Int {
        return NSString(string: self).integerValue
    }
    
    /// String 值转 Float
    var float: Float {
        return NSString(string: self).floatValue
    }
    
    /// String 值转 Double
    var double: Double {
        return NSString(string: self).doubleValue
    }
    
    /// String 值转 Data
    var data: Data? {
        return data(using: .utf8)
    }
    
    /// String 值转 NSAttributeString
    var attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }
    
    /// 获取 String 的每个字符（集合）
    var characters: [Character] {
        return Array(self)
    }
    
    /// 获取字符串汉字个数
    var chinaWordCount: Int {
        return characters.reduce(0, { $0 + (String($1).lengthOfBytes(using: .utf8) == 3 ? 2 : 0) })
    }
    
    /// 获取字符数（中文计2字符）
    var textInputCount: Int {
        return characters.reduce(0, { $0 + (String($1).lengthOfBytes(using: .utf8) == 3 ? 2 : 1) })
    }
    
    /// 首字母，如果是中文取拼音首字母
    var firstLetter: String {
        guard count > 0 else {
            return ""
        }
        let firstWord = String(characters[0])
        if String(characters[0]).lengthOfBytes(using: .utf8) == 1 {
            return firstWord
        }
        return pinyin.substring(to: 1)
    }
    
    /// 拼音
    var pinyin: String {
        let result = NSMutableString.init(string: self)
        // 带声调 - kCFStringTransformMandarinLatin
        // 去声调
        CFStringTransform(result, UnsafeMutablePointer.init(bitPattern: 0), kCFStringTransformStripDiacritics, false)
        return result as String
    }
    
    /// 默认去首尾空格及换行
    func trimmed(in set: CharacterSet = .whitespacesAndNewlines) -> String {
        return trimmingCharacters(in: set)
    }
    
    /// String转日期Date
    /// - Parameter format: 日期格式，默认 "yyyy-MM-dd HH:mm:ss"
    /// - Returns: 日期Date
    func date(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> Date? {
        let selfLowercased = trimmed().lowercased()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = format
        return formatter.date(from: selfLowercased)
    }
    
    /// 随机字符串
    /// - Parameters:
    ///   - count: 位数
    ///   - type: 类型：数字+字母，寸数字，纯字母
    /// - Returns: 随机字符串
    static func random(_ count: Int, type: BMRandomStringType = .default) -> String {
        var chars = ""
        switch type {
        case .default:
            chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        case .digitsOnly:
            chars = "0123456789"
        case .lettersOnly:
            chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }
        var randomString = ""
        for _ in 0..<count {
            let random = Int.random(in: 0..<chars.count)
            randomString.append(chars.character(at: random))
        }
        return randomString
    }
    
}

// MARK: - 字符串判断

public extension String {
    
    /// Email判断
    /// - Returns: 是或否
    func isValidEmail() -> Bool {
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    /// 是否是身份证号码
    /// - Returns: 是或否
    func isIdCard() -> Bool {
        return isMatch("(^[0-9]{15}$)|([0-9]{17}([0-9]|X)$)")
    }
    
    /// 是否纯数字，不含小数点
    /// - Returns: 是或否
    func isDigits() -> Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    
    /// 是否是十进制数字，可以包含小数点
    /// - Returns: 是或否
    func isNumeric() -> Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        #if os(Linux)
        return scanner.scanDecimal() != nil && scanner.isAtEnd
        #else
        return scanner.scanDecimal(nil) && scanner.isAtEnd
        #endif
    }
    
    /// 是否是数字/字母
    var isNumberOrLetter: Bool {
        return isMatch("^[a-zA-Z0-9]+$")
    }
    
    /// 正则匹配
    /// - Parameter pred: 正则表达式
    /// - Returns: 是或否
    func isMatch(_ pred: String ) -> Bool {
        let pred = NSPredicate(format: "SELF MATCHES %@", pred)
        let isMatch: Bool = pred.evaluate(with: self)
        return isMatch
    }
    
    /// 是否是空白符或换行符
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
}

// MARK: - 字符串截取

public extension String {
    
    /// 获取对应索引的字符
    ///
    /// - Parameter index: 索引
    /// - Returns: 返回字符
    func character(at index: Int) -> Character {
        self[self.index(startIndex, offsetBy: index)]
    }
    
    /// 截取字符串 from 索引
    ///
    /// - Parameter index: 索引
    /// - Returns: 截取后的字符串
    func substring(from index: Int) -> String {
        String(self[self.index(startIndex, offsetBy: index)...])
    }
    
    /// 截取字符串 to 索引
    ///
    /// - Parameter index: 索引
    /// - Returns: 截取后的字符串
    func substring(to index: Int) -> String {
        guard index <= count else {
            return ""
        }
        return String(self[..<self.index(startIndex, offsetBy: index)])
    }
    
    /// 通过Range截取字符串
    ///
    ///     "abc".substring(with: 1..<3) -> bc
    ///
    /// - Parameter range: Range
    /// - Returns: 截取后的字符串
    func substring(with range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound > 0 ? range.lowerBound : 0)
        let end = index(startIndex, offsetBy: range.upperBound < count ? range.upperBound : count)
        return String(self[start..<end])
    }
    
    /// 截取指定范围内的字符串（CountableClosedRange）
    ///
    ///     "abc".substring(with: 1...2) -> bc
    ///
    /// - Parameter range: 范围
    /// - Returns: 截取后的字符串
    func substring(with range: ClosedRange<Int>) -> String {
        substring(with: Range(uncheckedBounds: (lower: range.lowerBound, upper: range.upperBound + 1)))
    }
    
    /// 是否包含字符串
    ///
    /// - Parameters:
    ///   - string: 需要匹配的字符串
    ///   - caseSensitive: 区分大小写
    /// - Returns: 是否包含
    func has(_ string: String, caseSensitive: Bool = true) -> Bool {
        caseSensitive ? (range(of: string) != nil) : (lowercased().range(of: string.lowercased()) != nil)
    }
    
}

// MARK: 文本高度计算

public extension String {
    
    /// 计算文本高度
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 最大宽度
    ///   - lineSpace: 行间距
    ///   - alignment: 对齐方式
    /// - Returns: 文本高度
    func height(with font: UIFont, width: CGFloat, lineSpace: CGFloat = 0, alignment: NSTextAlignment = .left) -> CGFloat {
        return ceil(size(with: font, width: width, lineSpace: lineSpace, alignment: alignment).height)
    }
    
    /// 计算文本宽度
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - height: 最大高度
    ///   - lineSpace: 行间距
    ///   - alignment: 对齐方式
    /// - Returns: 文本宽度
    func width(with font: UIFont, height: CGFloat, lineSpace: CGFloat = 0, alignment: NSTextAlignment = .left) -> CGFloat {
        return ceil(size(with: font, height: height, lineSpace: lineSpace, alignment: alignment).width)
    }
    
    /// 计算文本宽高
    ///
    /// - Parameters:
    ///   - font: 字体
    ///   - width: 宽
    ///   - height: 高
    ///   - lineSpace: 行间距
    ///   - alignment: 对齐方式
    /// - Returns: 文本宽高
    private func size(with font: UIFont, width: CGFloat? = nil, height: CGFloat? = nil, lineSpace: CGFloat = 0, alignment: NSTextAlignment = .left) -> CGSize {
        guard !isEmpty else {
            return .zero
        }
        var tempSize: CGSize = .zero
        if let width = width, width > 0 {
            tempSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        }
        if let height = height, height > 0 {
            tempSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        }
        guard tempSize != .zero else {
            return .zero
        }
        // 未设置行间距
        if lineSpace <= 0 {
            let rect = (self as NSString).boundingRect(with: tempSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
            return rect.size
            
        }
        // 设置了行间距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace
        paragraphStyle.alignment = alignment
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .paragraphStyle: paragraphStyle]
        let attributesStr = NSAttributedString(string: self, attributes: attributes)
        let rect = attributesStr.boundingRect(with: tempSize, options: .usesLineFragmentOrigin, context: nil)
        return rect.size
    }
    
}

// MARK: json转Dictionary、Array

public extension String {
    
    func toDictionary() -> [String : Any]? {
        
        guard let data = data(using: String.Encoding.utf8),
              let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String : Any] else {
            return nil
        }
        return dictionary
    }
    
    func toArray() -> [Any]? {
        
        guard let data = data(using: String.Encoding.utf8),
              let array = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any] else {
            return nil
        }
        return array
    }
    
}
