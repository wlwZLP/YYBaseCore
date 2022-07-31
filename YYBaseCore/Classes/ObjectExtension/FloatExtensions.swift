//
//  FloatExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public extension Float {
    
    /// Float 值转 String
    var string: String {
        return String(format: "%f", self)
    }
    
    /// Float 值转 CGFloat
    var cgFloat: CGFloat {
        return CGFloat(self)
    }
    
    /// Float 值转 Double
    var double: Double {
        return Double(self)
    }
    
}
