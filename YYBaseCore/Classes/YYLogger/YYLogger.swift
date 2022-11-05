//
//  Logger.swift
//  Wallet
//
//  Created by james on 2018/7/2.
//

import Foundation

public class YYLogger: LoggerProtocol {

    public static let `default` = YYLogger()

    public var loggers: [LoggerProtocol] = [LocalLogger()]

    public func addLogger(_ logger: LoggerProtocol) {
        loggers.append(logger)
    }

    ///debug 打印
    public static func debug(_ message: Any, category: String = "BitMart") {
        YYLogger.default.debug(message, category: category)
    }
    public func debug(_ message: Any, category: String = "BitMart") {
        for logger in loggers {
            logger.debug(message, category: category)
        }
    }

    ///info 打印
    public static func info(_ message: Any, category: String = "BitMart") {
        YYLogger.default.info(message, category: category)
    }
    public func info(_ message: Any, category: String = "BitMart") {
        for logger in loggers {
            logger.info(message, category: category)
        }
    }

    ///error 打印
    public static func error(_ message: Any, category: String = "BitMart") {
        YYLogger.default.error(message, category: category)
    }
    public func error(_ message: Any, category: String = "BitMart") {
        for logger in loggers {
            logger.error(message, category: category)
        }
    }

}
