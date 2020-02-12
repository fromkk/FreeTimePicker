//
//  EventEntity.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/11.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

struct EventEntity {
    let title: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
}

extension Collection where Element == EventEntity {
    func search(in date: Date, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> [EventEntity] {
        var calendar = calendar
        calendar.timeZone = timeZone
        var appendDateComponents = DateComponents()
        appendDateComponents.calendar = calendar
        appendDateComponents.timeZone = timeZone
        appendDateComponents.day = 1
        appendDateComponents.second = -1

        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: appendDateComponents, to: startDate)!

        return filter { entity in
            if startDate <= entity.startDate, endDate >= entity.endDate {
                return true
            } else if startDate >= entity.startDate, endDate <= entity.endDate {
                return true
            } else {
                return false
            }
        }
    }
}
