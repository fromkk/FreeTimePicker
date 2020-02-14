//
//  FreeTimePickerIntentHandler.swift
//  Siri
//
//  Created by Kazuya Ueoka on 2020/02/13.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation
import Intents
import Core
import Combine

final class FreeTimePickerIntentHandler: NSObject, FreeTimePickerIntentHandling {
    private var cancellables: [AnyCancellable] = []
    private let calculator = EventDateCalculator()
    @UserDefaultsWrapper<Bool, Constants.SearchParameterKeys>(key: .ignoreAllDays, userDefaults: .grouped, defaultValue: true)
    private var ignoreAllDay: Bool
    @UserDefaultsWrapper<Bool, Constants.SearchParameterKeys>(key: .ignoreHolidays, userDefaults: .grouped, defaultValue: true)
    private var ignoreHolidays: Bool
    @UserDefaultsWrapper<Date, Constants.SearchParameterKeys>(key: .transitTimeDate, userDefaults: .grouped, defaultValue: FreeTimePickerIntentHandler.makeTime(hour: 0, minutes: 30))
    private var transitTime: Date
    @UserDefaultsWrapper<Date, Constants.SearchParameterKeys>(key: .minFreeTimeDate, userDefaults: .grouped, defaultValue: FreeTimePickerIntentHandler.makeTime(hour: 1, minutes: 0))
    private var minFreeTime: Date
    @UserDefaultsWrapper<Date, Constants.SearchParameterKeys>(key: .fromTime, userDefaults: .grouped, defaultValue: FreeTimePickerIntentHandler.makeTime(hour: 9, minutes: 0))
    private var startTime: Date
    @UserDefaultsWrapper<Date, Constants.SearchParameterKeys>(key: .toTime, userDefaults: .grouped, defaultValue: FreeTimePickerIntentHandler.makeTime(hour: 22, minutes: 0))
    private var endTime: Date

    private static func makeTime(hour: Int, minutes: Int, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        let startDate = calendar.startOfDay(for: Date())
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minutes
        return calendar.date(byAdding: dateComponents, to: startDate)!
    }
    
    private static func timeInterval(of date: Date, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> TimeInterval {
        var calendar = calendar
        calendar.timeZone = timeZone
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        let minute: TimeInterval = 60.0
        let hour: TimeInterval = 60.0 * 60.0
        return TimeInterval(dateComponents.hour!) * hour + TimeInterval(dateComponents.minute!) * minute
    }

    private func performSearchFreeTime(in searchDateType: SearchDateType, with completion: @escaping (FreeTimePickerIntentResponse) -> Void) {
        CalendarPermissionRepository().request { [weak self] (granted) in
            guard let self = self else { return }
            guard granted else {
                completion(.success(result: NSLocalizedString("No permissions", comment: "No permissions")))
                return
            }
            let (fromDate, toDate) = searchDateType.dates()
            EventRepository().fetch(startDate: fromDate, endDate: toDate, ignoreAllDay: self.ignoreAllDay).sink { [weak self] (events) in
                guard let self = self else { return }
                let result = FreeTimeFinder.find(
                    with: self.calculator,
                    in: events,
                    from: fromDate,
                    to: toDate,
                    startDate: self.startTime,
                    endDate: self.endTime,
                    freeTime: Self.timeInterval(of: self.minFreeTime),
                    transitTime: Self.timeInterval(of: self.transitTime),
                    ignoreHolidays: self.ignoreHolidays
                )
                completion(.success(result: FreeTimeConverter(dates: result).toString()))
            }.store(in: &self.cancellables)
        }
    }

    func resolveDateType(for intent: FreeTimePickerIntent, with completion: @escaping (DateTypeResolutionResult) -> Void) {
        guard let _  = intent.dateType.toSearchDateType() else {
            completion(.confirmationRequired(with: .tomorrow))
            return
        }
        completion(.success(with: intent.dateType))
    }

    func confirm(intent: FreeTimePickerIntent, completion: @escaping (FreeTimePickerIntentResponse) -> Void) {
        guard let searchDateType  = intent.dateType.toSearchDateType() else {
            return
        }
        performSearchFreeTime(in: searchDateType, with: completion)
    }

    func handle(intent: FreeTimePickerIntent, completion: @escaping (FreeTimePickerIntentResponse) -> Void) {
        guard let searchDateType  = intent.dateType.toSearchDateType() else {
            return
        }
        performSearchFreeTime(in: searchDateType, with: completion)
    }
}
