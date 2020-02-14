//
//  DateCreator.swift
//  CoreTests
//
//  Created by Kazuya Ueoka on 2020/02/15.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

enum DateCreator {
    static func create(year: Int, month: Int, day: Int, hour: Int, minute: Int, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = 0
        dateComponents.nanosecond = 0
        return calendar.date(from: dateComponents)!
    }
}
