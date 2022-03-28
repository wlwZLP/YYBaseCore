//
//  DecimalExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public extension Decimal {
    
    /// Decimal 值转 String
    var string: String {
        return NSDecimalNumber(decimal: self).stringValue
    }
    
    /// Decimal 值转 NSNumber
    var number: NSNumber {
        return self as NSNumber
    }
    
    /// Decimal 值转成 千分位格式的字符串
    var thousandthString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.usesGroupingSeparator = true
        formatter.decimalSeparator = ","
        return formatter.string(from: self.number) ?? "0"
    }
    
}
