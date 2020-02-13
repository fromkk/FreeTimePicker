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
    private var ignoreAllDay: Bool = true
    private var ignoreHolidays: Bool = false
    private var transitTime: TimeInterval = 60.0 * 60.0
    private var minFreeTime: TimeInterval = 60.0 * 60.0
    private lazy var startTime: Date = self.makeTime(hour: 9, minutes: 0)
    private lazy var endTime: Date = self.makeTime(hour: 22, minutes: 0)

    private func makeTime(hour: Int, minutes: Int, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        let startDate = calendar.startOfDay(for: Date())
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minutes
        return calendar.date(byAdding: dateComponents, to: startDate)!
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
                    freeTime: self.minFreeTime,
                    transitTime: self.transitTime,
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
