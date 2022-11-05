//
//  Then.swift
//  Core
//
//  Created by Chris on 2022/3/15.
//

import Foundation
import CoreGraphics
import UIKit.UIGeometry

public protocol Then { }

extension Then where Self: Any {

    /// 值类型对象初始化或者赋值后, 可以在闭包内部进行属性设值
    /// - Parameter block: 外部传入的需要执行的闭包
    /// - Returns: 返回当前类型的实例 ( 自己 )
    @inlinable
    public func with(_ block: (inout Self) throws -> Void) rethrows -> Self {
        var copy = self
        try block(&copy)
        return copy
    }
    
    /// 值类型初始化以后, 可以马上执行闭包内的任务
    /// - Parameter block: 外部传入的需要执行的闭包
    @inlinable
    public func `do`(_ block: (Self) throws -> Void) rethrows {
        try block(self)
    }

}

extension Then where Self: AnyObject {
    /// 引用类型的对象初始化时, 可以在闭包内部进行属性设值
    /// - Parameter block: 外部传入的需要执行的闭包
    /// - Returns: 返回当前类型的实例 ( 自己 )
    @inlinable
    public func then(_ block: (Self) throws -> Void) rethrows -> Self {
        try block(self)
        return self
    }

}

extension NSObject: Then {}
extension CGPoint: Then {}
extension CGRect: Then {}
extension CGSize: Then {}
extension CGVector: Then {}
extension Array: Then {}
extension Dictionary: Then {}
extension Set: Then {}
extension UIEdgeInsets: Then {}
extension UIOffset: Then {}
extension UIRectEdge: Then {}

