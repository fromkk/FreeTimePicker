//
//  SearchParametersStore.swift
//  FreeTimePicker
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Core
import Foundation

final class SearchParametersStore {
    static var userDefaults: UserDefaults = .grouped

    @UserDefaultsOptionalWrapper<Int, Constants.SearchParameterKeys>(key: .searchDateType, userDefaults: SearchParametersStore.userDefaults)
    var searchDateType: Int?

    @UserDefaultsOptionalWrapper<Date, Constants.SearchParameterKeys>(key: .minFreeTimeDate, userDefaults: SearchParametersStore.userDefaults)
    var minFreeTimeDate: Date?

    @UserDefaultsOptionalWrapper<Date, Constants.SearchParameterKeys>(key: .fromTime, userDefaults: SearchParametersStore.userDefaults)
    var fromTime: Date?

    @UserDefaultsOptionalWrapper<Date, Constants.SearchParameterKeys>(key: .toTime, userDefaults: SearchParametersStore.userDefaults)
    var toTime: Date?

    @UserDefaultsOptionalWrapper<Date, Constants.SearchParameterKeys>(key: .transitTimeDate, userDefaults: SearchParametersStore.userDefaults)
    var transitTimeDate: Date?

    @UserDefaultsOptionalWrapper<Bool, Constants.SearchParameterKeys>(key: .ignoreAllDays, userDefaults: SearchParametersStore.userDefaults)
    var ignoreAllDays: Bool?

    @UserDefaultsOptionalWrapper<Bool, Constants.SearchParameterKeys>(key: .ignoreHolidays, userDefaults: SearchParametersStore.userDefaults)
    var ignoreHolidays: Bool?

    func restore(with viewModel: SearchViewModel) {
        viewModel.searchDateType = searchDateType.flatMap { SearchDateType(rawValue: $0) }
        viewModel.minFreeTimeDate = minFreeTimeDate ?? Self.defaultDate(hour: 1, minute: 0)
        viewModel.fromTime = fromTime ?? Self.defaultDate(hour: 9, minute: 0)
        viewModel.toTime = toTime ?? Self.defaultDate(hour: 22, minute: 0)
        viewModel.transitTimeDate = transitTimeDate ?? Self.defaultDate(hour: 0, minute: 30)
        viewModel.ignoreAllDays = ignoreAllDays ?? true
        viewModel.ignoreHolidays = ignoreHolidays ?? true
    }

    func save(with viewModel: SearchViewModel) {
        searchDateType = viewModel.searchDateType?.rawValue
        minFreeTimeDate = viewModel.minFreeTimeDate
        fromTime = viewModel.fromTime
        toTime = viewModel.toTime
        transitTimeDate = viewModel.transitTimeDate
        ignoreAllDays = viewModel.ignoreAllDays
        ignoreHolidays = viewModel.ignoreHolidays
    }

    private static func defaultDate(
        for date: Date = Date(),
        with calendar: Calendar = .init(identifier: .gregorian),
        timeZone: TimeZone = .current,
        hour: Int,
        minute: Int
    ) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        return calendar.startOfDay(for: date).addingTimeInterval(TimeInterval(hour) * 60 * 60 + TimeInterval(minute) * 60)
    }
}
