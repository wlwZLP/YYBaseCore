//
//  DispatchExtensions.swift
//  Core
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public struct GCD {
    
    public typealias ExTask = (_ cancel: Bool) -> Void
    
    /// 按照指定的时间延迟执行任务
    /// - Parameters:
    ///   - time: 需要延迟的时间, 单位秒
    ///   - task: 需要执行的任务
    /// - Returns: 任务类型实例
    @discardableResult
    public static func delay(_ time: Int, task: @escaping ()->()) -> ExTask? {
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + .seconds(time)
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (()->())? = task
        var result: ExTask?
        let delayedClosure: ExTask = { cancel in
            if let internalClosure = closure {
                if cancel == false {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }
    
    /// 取消执行指定的延迟任务
    /// - Parameter task: 需要取消执行的任务
    public static func cancel(_ task: ExTask?) {
        task?(true)
    }
    
    /// 创建一个GCD定时器
    /// - Parameters:
    ///   - timeInterval: 定时器时间间隔 ( 多少秒执行一次 )
    ///   - delay: 开启定时器以后, 延迟多少秒开始执行
    ///   - timerQueue: 当前 timer 所在的队列
    ///   - handlerQueue: 定时器执行定时任务事件所在的队列
    ///   - eventHandler: 定时器任务闭包
    /// - Returns: GCD定时器
    public static func timer(timeInterval: Int, delay: Int = 0, timerQueue: DispatchQueue = DispatchQueue.global(), handlerQueue: DispatchQueue? = DispatchQueue.main, eventHandler: (() -> Void)?) -> DispatchSourceTimer {
        let timer = DispatchSource.makeTimerSource(flags: .strict, queue: timerQueue)
        timer.schedule(deadline: .now() + .seconds(delay), repeating: .seconds(timeInterval))
        timer.setEventHandler {
            if let handlerQueue = handlerQueue {
                handlerQueue.async {
                    if let eventHandler = eventHandler {
                        eventHandler()
                    }
                }
            }
        }
        return timer
    }
    
    /// 开始/恢复 指定定时器
    /// - Parameter timer: GCD定时器实例
    public static func start(_ timer: DispatchSourceTimer?) {
        timer?.resume()
    }
    
    /// 停止 指定定时器 ( 停止后, 会销毁定时器 )
    /// - Parameter timer: GCD定时器实例
    public static func stop(_ timer: inout DispatchSourceTimer?) {
        timer?.cancel()
        timer = nil
    }
    
    /// 暂停 指定定时器 ( 暂停再恢复计时后, 会出现定时精度问题, 建议停止定时器, 再重新创建 )
    /// - Parameter timer: GCD定时器实例
    public static func pause(_ timer: DispatchSourceTimer?) {
        timer?.suspend()
    }
    
}
