//
//  SearchDateType.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

public enum SearchDateType: Int, CaseIterable, Identifiable, Equatable {
    case today
    case tomorrow
    case thisWeek
    case nextWeek
    case thisMonth
    case nextMonth
    case custom

    public var key: String {
        switch self {
        case .today:
            return "today"
        case .tomorrow:
            return "tomorrow"
        case .thisWeek:
            return "thisWeek"
        case .nextWeek:
            return "nextWeek"
        case .thisMonth:
            return "thisMonth"
        case .nextMonth:
            return "nextMonth"
        case .custom:
            return "custom"
        }
    }

    public var title: String {
        let key: String
        switch self {
        case .today:
            key = "Search date today"
        case .tomorrow:
            key = "Search date tomorrow"
        case .thisWeek:
            key = "Search date this week"
        case .nextWeek:
            key = "Search date next week"
        case .thisMonth:
            key = "Search date this month"
        case .nextMonth:
            key = "Search date next month"
        case .custom:
            key = "Search date custom"
        }
        return NSLocalizedString(key, comment: key)
    }

    public typealias Dates = (startDate: Date, endDate: Date)

    public func dates(with date: Date = Date(), calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current, locale: Locale = .current) -> Dates? {
        var calendar = calendar
        calendar.timeZone = timeZone
        calendar.locale = locale

        switch self {
        case .today:
            return today(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .tomorrow:
            return tomorrow(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .thisWeek:
            return thisWeek(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .nextWeek:
            return nextWeek(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .thisMonth:
            return thisMonth(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .nextMonth:
            return nextMonth(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .custom:
            return nil
        }
    }

    private func today(with date: Date, calendar: Calendar, timeZone: TimeZone, locale _: Locale) -> Dates {
        let startDate = calendar.startOfDay(for: date)
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.day = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (startDate, endDate)
    }

    private func tomorrow(with date: Date, calendar: Calendar, timeZone: TimeZone, locale _: Locale) -> Dates {
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.day = 1
        let tomorrow = calendar.date(byAdding: dateComponents, to: date)!
        let startDate = calendar.startOfDay(for: tomorrow)
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (startDate, endDate)
    }

    private func thisWeek(with date: Date, calendar: Calendar, timeZone: TimeZone, locale _: Locale) -> Dates {
        var dateComponents = calendar.dateComponents([.year, .month, .weekOfMonth], from: date)
        dateComponents.weekday = 1
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        let startDate = calendar.date(from: dateComponents)!
        dateComponents = .init()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.weekOfMonth = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (calendar.startOfDay(for: date), endDate)
    }

    private func nextWeek(with date: Date, calendar: Calendar, timeZone: TimeZone, locale _: Locale) -> Dates {
        var dateComponents = calendar.dateComponents([.year, .month, .weekOfMonth], from: date)
        dateComponents.weekday = 1
        dateComponents.weekOfMonth! += 1
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        let startDate = calendar.date(from: dateComponents)!
        dateComponents = .init()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.weekOfMonth = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (startDate, endDate)
    }

    private func thisMonth(with date: Date, calendar: Calendar, timeZone: TimeZone, locale _: Locale) -> Dates {
        var dateComponents = calendar.dateComponents([.year, .month], from: date)
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        let startDate = calendar.date(from: dateComponents)!
        dateComponents = .init()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.month = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (calendar.startOfDay(for: date), endDate)
    }

    private func nextMonth(with date: Date, calendar: Calendar, timeZone: TimeZone, locale _: Locale) -> Dates {
        var dateComponents = calendar.dateComponents([.year, .month], from: date)
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.month! += 1
        let startDate = calendar.date(from: dateComponents)!
        dateComponents = .init()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.month = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (startDate, endDate)
    }

    public var id: Int { rawValue }
}
