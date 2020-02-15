//
//  SearchViewModel.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import Core
import Foundation

final class SearchViewModel: ObservableObject {
    @Published var isValid: Bool = false
    @Published var searchDateType: SearchDateType?
    @Published var minFreeTimeDate: Date?
    @Published var minFreeTimeText: String?
    @Published var fromTime: Date?
    @Published var fromText: String?
    @Published var toTime: Date?
    @Published var toText: String?
    @Published var transitTimeDate: Date?
    @Published var transitTimeText: String?
    @Published var ignoreAllDays: Bool = true
    @Published var ignoreHolidays: Bool = true
    private var _search: PassthroughSubject<Void?, Never> = .init()

    private var cancellables: [AnyCancellable] = []

    typealias RangeOfDates = (Date?, Date?)
    typealias Ignores = (allDay: Bool, holidays: Bool)
    @Published var result: [(Date, Date)] = []
    @Published var hasResults: Bool = false
    @Published var noResults: Bool = false

    let eventRepository: EventRepositoryProtocol
    let parametersStore: SearchParametersStore = .init()
    private let calculator: EventDateCalculator = .init()

    init(eventRepository: EventRepositoryProtocol) {
        self.eventRepository = eventRepository
        parametersStore.restore(with: self)
        bind()
    }

    private func bind() {
        let fromTo = Publishers.CombineLatest($fromTime, $toTime)
        let freeTimeAndTransitTime = Publishers.CombineLatest($minFreeTimeDate, $transitTimeDate)
        let ignores = Publishers.CombineLatest($ignoreAllDays, $ignoreHolidays)
        let combine = Publishers.CombineLatest4($searchDateType, fromTo, freeTimeAndTransitTime, ignores).share()
        combine.sink { [weak self] arg in
            let (searchDateType, fromTo, freeTimeAndTransitTime, ignores) = arg
            self?.handleIsValid(searchDateType: searchDateType, fromTo: fromTo, freeTimeAndTransitTime: freeTimeAndTransitTime, ignores: ignores)
        }.store(in: &cancellables)

        _search
            .combineLatest(combine)
            .filter { $0.0 != nil }
            .map { $0.1 }
            .sink { [weak self] searchDateType, fromTo, freeTimeAndTransitTime, ignores in
                guard let searchDateType = searchDateType else { return }
                self?.performSearch(searchDateType: searchDateType, fromTo: fromTo, freeTimeAndTransitTime: freeTimeAndTransitTime, ignores: ignores)
            }.store(in: &cancellables)
    }

    func search() {
        _search.send(())
        _search.send(nil)
    }

    private func handleIsValid(searchDateType: SearchDateType?, fromTo: RangeOfDates, freeTimeAndTransitTime: RangeOfDates, ignores _: Ignores) {
        let isValidFromTo: Bool = {
            if let from = fromTo.0, let to = fromTo.1 {
                return from < to
            } else {
                return false
            }
        }()

        isValid = searchDateType != nil && isValidFromTo && freeTimeAndTransitTime.0 != nil && freeTimeAndTransitTime.1 != nil
    }

    private func performSearch(searchDateType: SearchDateType, fromTo: RangeOfDates, freeTimeAndTransitTime: RangeOfDates, ignores: Ignores) {
        guard let startTime = fromTo.0, let endTime = fromTo.1, let freeTime = freeTimeAndTransitTime.0, let transitTime = freeTimeAndTransitTime.1 else {
            return
        }

        let (from, to) = searchDateType.dates()
        eventRepository.fetch(startDate: from, endDate: to, ignoreAllDay: ignores.allDay)
            .sink { [weak self] events in
                guard let self = self else { return }
                self.searchFreeTime(
                    in: events,
                    from: from,
                    to: to,
                    startTime: startTime,
                    endTime: endTime,
                    freeTime: self.timeInterval(of: freeTime),
                    transitTime: self.timeInterval(of: transitTime),
                    ignoreAllDay: ignores.allDay,
                    ignoreHolidays: ignores.holidays
                )
            }.store(in: &cancellables)
    }

    private func timeInterval(of date: Date, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> TimeInterval {
        var calendar = calendar
        calendar.timeZone = timeZone
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        let minute: TimeInterval = 60.0
        let hour: TimeInterval = 60.0 * 60.0
        return TimeInterval(dateComponents.hour!) * hour + TimeInterval(dateComponents.minute!) * minute
    }

    private func searchFreeTime(in events: [EventEntity], from: Date, to: Date, startTime: Date, endTime: Date, freeTime: TimeInterval, transitTime: TimeInterval, ignoreAllDay _: Bool, ignoreHolidays: Bool) {
        parametersStore.save(with: self)
        result = FreeTimeFinder.find(
            with: calculator,
            in: events,
            from: from,
            to: to,
            startTime: startTime,
            endTime: endTime,
            freeTime: freeTime,
            transitTime: transitTime,
            ignoreAllDay: ignoreAllDays,
            ignoreHolidays: ignoreHolidays
        )
        hasResults = result.count > 0
        noResults = result.count == 0
    }
}
