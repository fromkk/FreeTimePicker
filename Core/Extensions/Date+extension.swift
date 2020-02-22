//
//  Date+extension.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/13.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

extension Date {
    public func isHoliday(_ calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Bool {
        var calendar = calendar
        calendar.timeZone = timeZone
        return [1, 7].contains(calendar.component(.weekday, from: self))
    }

    public func startOfDay(calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        return calendar.startOfDay(for: self)
    }

    public func endOfDay(calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        var addingDateComponents = DateComponents()
        addingDateComponents.day = 1
        return calendar.date(byAdding: addingDateComponents, to: calendar.startOfDay(for: self))!.advanced(by: -1)
    }
}
