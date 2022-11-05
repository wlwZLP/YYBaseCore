//
//  Application.swift
//  Core
//
//  Created by Chris on 2022/3/17.
//

import Foundation


// MARK: 需要在App启动时，在DidFinishLaunching之前做事的类，需要遵循该协议，并实现以下方法
public protocol ApplicationLaunching {
    /// DidFinishLaunching方法之前需要执行的方法，可以在该方法的实现中调用
    static func runBeforeLaunching()
    /// DidFinishLaunching方法中需要执行的方法，可以在该方法的实现中调用
    static func runDidLaunching()
    /// DidFinishLaunching方法之后需要执行的方法，可以在该方法的实现中调用
    static func runAfterLaunching()
}

public extension ApplicationLaunching {
    /// DidFinishLaunching方法之前需要执行的方法，可以在该方法的实现中调用
    static func runBeforeLaunching() { }
    /// DidFinishLaunching方法中需要执行的方法，可以在该方法的实现中调用
    static func runDidLaunching() { }
    /// DidFinishLaunching方法之后需要执行的方法，可以在该方法的实现中调用
    static func runAfterLaunching() { }
}

// MARK: 以下方法在壳工程里面调用，无需业务开发同学调用获过多关注
public extension UIApplication {
    /// App刚启动的时候，需要做的事情，在DidFinishLaunchingWithOptions之前
    /// 需要在AppDelegate中的willFinishLaunchingWithOptions方法中调用，才会生效
    static let applicationBeforeLaunching: Void = {
        UIApplication.runBeforeLaunchingFunctions()
        // 执行方法交换
        UIApplication.runAwareFunctions()
    }()
    
    /// App启动中，需要做的事情，在DidFinishLaunchingWithOptions方法中
    /// 需要在AppDelegate中的DidFinishLaunchingWithOptions方法中调用，才会生效
    static let applicationDidLaunching: Void = {
        UIApplication.runDidLaunchingFunctions()
    }()
    
    /// App启动后，需要做的事情
    /// 可以在AppDelegate中的DidFinishLaunchingWithOptions方法中调用，只有调用后才会生效
    static let applicationAfterLaunching: Void = {
        DispatchQueue.global().async {
            UIApplication.runAfterLaunchingFunctions()
        }
    }()
    
    /// App刚启动的时候，需要做的事情
    /// 对应 applicationBeforeLaunching 属性的实现
    private static func runBeforeLaunchingFunctions() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? ApplicationLaunching.Type)?.runBeforeLaunching()
        }
        types.deallocate()
    }
    
    /// App启动中，需要做的事情
    /// 对应 applicationDidLaunching 属性的实现
    private static func runDidLaunchingFunctions() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? ApplicationLaunching.Type)?.runDidLaunching()
        }
        types.deallocate()
    }
    
    /// App启动后，需要做的事情
    /// 对应 applicationAfterLaunching 属性的实现
    private static func runAfterLaunchingFunctions() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            if let objectType = types[index] as? ApplicationLaunching.Type {
                DispatchQueue.main.async {
                    objectType.runAfterLaunching()
                }
            }
        }
        types.deallocate()
    }
    
}

public extension UIApplication {
    /// 执行方法交换
    /// 调用遵循 BMAware 协议的对象的 awake 方法
    private static func runAwareFunctions() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? Aware.Type)?.awake()
        }
        types.deallocate()
    }
    
}

