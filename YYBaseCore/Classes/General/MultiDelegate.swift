//
//  MultiDelegate.swift
//  Core
//
//  Created by Chris on 2022/3/10.
//

import Foundation

private var multiDelegatesKey: Void?
/// 多代理协议
public protocol MultiDelegate {
    /// 添加代理对象
    /// - Parameter object: 代理对象
    func addDelegate(_ object: AnyObject)
    /// 遍历获取所有的代理对象
    /// - Parameter object: 代理对象
    func enumerator(_ object: (AnyObject) -> Void)
}

/// 多代理协议默认实现
public extension MultiDelegate where Self: AnyObject {
    /// 遍历获取所有的代理对象
    /// - Parameter object: 代理对象
    func enumerator(_ object: (AnyObject) -> Void) {
        for item in delegates.allObjects {
            object(item)
        }
    }
    
    /// 添加代理对象
    /// - Parameter object: 代理对象
    func addDelegate(_ object: AnyObject) {
        delegates.add(object)
    }
    
    /// 利用关联对象添加delegates属性
    private var delegates: NSHashTable<AnyObject> {
        get {
            if let delegates = objc_getAssociatedObject(self, &multiDelegatesKey) as? NSHashTable<AnyObject> {
                return delegates
            }
            self.delegates = NSHashTable<AnyObject>(options: .weakMemory)
            return self.delegates
        }
        set {
            objc_setAssociatedObject(self, &multiDelegatesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
