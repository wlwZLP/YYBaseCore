//
//  Awake.swift
//  Core
//
//  Created by Chris on 2022/3/11.
//

import Foundation

/// 需要做方法交换的类, 必须实现该协议
public protocol Aware {
    /// 在该方法中调用方法交换的封装方法，需要自己实现
    static func awake()
    
    /// 方法交换方法 （该方法已有默认实现, 无需自己实现）
    static func swizzlingForClass(forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector)
}

public extension Aware {
    // 默认实现该方法, 相当于对方法交换进行了封装
    static func swizzlingForClass(forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        guard (originalMethod != nil && swizzledMethod != nil) else {
            return
        }
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
}

