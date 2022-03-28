//
//  DateExtensions.swift
//  BMCore
//
//  Created by Chris on 2022/3/8.
//

import Foundation

public extension Date {
    
    /// 日期字符串+日期格式，初始化日期
    /// - Parameters:
    ///   - dataString: 日期字符串
    ///   - format: 日期格式，默认 "yyyy-MM-dd HH:mm:ss"
    init?(dataString: String, format: String = "yyyy-MM-dd HH:mm:ss") {
        // https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: dataString) else { return nil }
        self = date
    }
    
    private var calendar: Calendar {
        return Calendar(identifier: Calendar.current.identifier)
        // Workaround to segfault on corelibs foundation https://bugs.swift.org/browse/SR-10147
    }
    
    /// 年
    var year: Int {
        get {
            return calendar.component(.year, from: self)
        }
        set {
            guard newValue > 0 else { return }
            let currentYear = calendar.component(.year, from: self)
            let yearsToAdd = newValue - currentYear
            if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 月
    var month: Int {
        get {
            return calendar.component(.month, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .month, in: .year, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMonth = calendar.component(.month, from: self)
            let monthsToAdd = newValue - currentMonth
            if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 日
    var day: Int {
        get {
            return calendar.component(.day, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentDay = calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 当前日期为一星期的第几天，
    /// 周日为1，周一为2，以此类推
    var weekday: Int {
        return calendar.component(.weekday, from: self)
    }
    
    /// 当前日期为星期几
    var weekdayName: String {
        let names = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        return names[weekday - 1]
    }
    
    /// 小时
    var hour: Int {
        get {
            return calendar.component(.hour, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentHour = calendar.component(.hour, from: self)
            let hoursToAdd = newValue - currentHour
            if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 分钟
    var minute: Int {
        get {
            return calendar.component(.minute, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentMinutes = calendar.component(.minute, from: self)
            let minutesToAdd = newValue - currentMinutes
            if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 秒
    var second: Int {
        get {
            return calendar.component(.second, from: self)
        }
        set {
            let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentSeconds = calendar.component(.second, from: self)
            let secondsToAdd = newValue - currentSeconds
            if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self) {
                self = date
            }
        }
    }
    
    /// 是否当天
    var isToday: Bool {
        return calendar.isDateInToday(self)
    }
    
    /// 是否昨天
    var isYesterday: Bool {
        return calendar.isDateInYesterday(self)
    }
    
    /// 毫秒时间戳
    var timestampMilliSeconds: String {
        return String(Int64(timeIntervalSince1970 * 1000))
    }
    
    /// 秒时间戳
    var timestampSeconds: String {
        return String(Int64(timeIntervalSince1970))
    }
    
    /// 日期转String
    /// - Parameter format: 日期格式，默认 "yyyy-MM-dd HH:mm:ss"
    /// - Returns: String
    func string(withFormat format: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
