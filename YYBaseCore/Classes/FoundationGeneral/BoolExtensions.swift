//
//  BoolExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public extension Bool {
    
    /// Bool 值转 Int
    var int: Int {
        return self ? 1 : 0
    }
    
    /// Bool 值转 String
    var string: String {
        return self ? "true" : "false"
    }
}
