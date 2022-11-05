//
//  QGLogger.swift
//  BitMart
//
//  Created by james on 16/3/25.
//  Copyright © 2016年 james. All rights reserved.
//

import Foundation
import os.log

public protocol LoggerProtocol {
    func debug(_ message: Any, category: String)
    func info(_ message: Any, category: String)
    func error(_ message: Any, category: String)
}

public struct LocalLogger: LoggerProtocol {
    
    private static let subsystem = "com.bitMart"

    public static func debug(_ message: Any, category: String) {
        #if DEBUG
            let log = OSLog(subsystem: subsystem, category: category)
            os_log("⚪️ DEBUG - %@", log: log, type: .debug, "\(message)")
        #endif
    }
    public func debug(_ message: Any, category: String) {
        #if DEBUG
            let log = OSLog(subsystem: LocalLogger.subsystem, category: category)
            os_log("⚪️ DEBUG - %@", log: log, type: .debug, "\(message)")
        #endif
    }

    public static func info(_ message: Any, category: String) {
        let log = OSLog(subsystem: subsystem, category: category)
        os_log("🔵 INFO - %@", log: log, type: .info, "\(message)")
    }
    public func info(_ message: Any, category: String) {
        let log = OSLog(subsystem: LocalLogger.subsystem, category: category)
        os_log("🔵 INFO - %@", log: log, type: .info, "\(message)")
    }


    public static func error(_ message: Any, category: String) {
        let log = OSLog(subsystem: subsystem, category: category)
        os_log("🔴 ERROR - %@", log: log, type: .error, "\(message)")
    }
    public func error(_ message: Any, category: String) {
        let log = OSLog(subsystem: LocalLogger.subsystem, category: category)
        os_log("🔴 ERROR - %@", log: log, type: .error, "\(message)")
    }


}
