//
//  SearchViewModel.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var isValid: Bool = false
    @Published var searchDateType: SearchDateType? = nil
    @Published var minFreeTimeDate: Date? = nil
    @Published var minFreeTimeText: String? = nil
    @Published var fromTime: Date? = nil
    @Published var fromText: String? = nil
    @Published var toTime: Date? = nil
    @Published var toText: String? = nil
    @Published var transitTimeDate: Date? = nil
    @Published var transitTimeText: String? = nil
    @Published var ignoreAllDays: Bool = true
    private var _search: PassthroughSubject<Void?, Never> = .init()
    
    private var cancellables: [AnyCancellable] = []

    typealias Range = (Date?, Date?)
    
    let eventRepository: EventRepositoryProtocol
    private let calculator: EventDateCalculator = .init()

    init(eventRepository: EventRepositoryProtocol) {
        self.eventRepository = eventRepository
        bind()
    }
    
    private func bind() {
        let fromTo = Publishers.CombineLatest($fromTime, $toTime)
        let freeTimeAndTransitTime = Publishers.CombineLatest($minFreeTimeDate, $transitTimeDate)
        let combine = Publishers.CombineLatest4($searchDateType, fromTo, freeTimeAndTransitTime, $ignoreAllDays).share()
        combine.sink { [weak self] searchDateType, fromTo, freeTimeAndTransitTime, ignoreAllDays in
                self?.handleIsValid(searchDateType: searchDateType, fromTo: fromTo, freeTimeAndTransitTime: freeTimeAndTransitTime, ignoreAllDays: ignoreAllDays)
            }.store(in: &cancellables)

        _search.filter { $0 != nil }
            .combineLatest(combine, { $1 })
                .sink { [weak self] searchDateType, fromTo, freeTimeAndTransitTime, ignoreAllDays in
                    guard let searchDateType = searchDateType else { return }
                    self?.performSearch(searchDateType: searchDateType, fromTo: fromTo, freeTimeAndTransitTime: freeTimeAndTransitTime, ignoreAllDays: ignoreAllDays)
            }.store(in: &cancellables)
    }

    func search() {
        _search.send(())
        _search.send(nil)
    }

    private func handleIsValid(searchDateType: SearchDateType?, fromTo: Range, freeTimeAndTransitTime: Range, ignoreAllDays: Bool) {
        let isValidFromTo: Bool = {
            if let from = fromTo.0, let to = fromTo.1 {
                return from < to
            } else {
                return false
            }
        }()

        isValid = searchDateType != nil && isValidFromTo && freeTimeAndTransitTime.0 != nil && freeTimeAndTransitTime.1 != nil
    }

    private func performSearch(searchDateType: SearchDateType, fromTo: Range, freeTimeAndTransitTime: Range, ignoreAllDays: Bool) {
        guard let startDate = fromTo.0, let endDate = fromTo.1, let freeTime = freeTimeAndTransitTime.0, let transitTime = freeTimeAndTransitTime.1 else {
            return
        }

        let (from, to) = searchDateType.dates()
        eventRepository.fetch(startDate: from, endDate: to, ignoreAllDay: ignoreAllDays)
            .sink { [weak self] events in
                guard let self = self else { return }
                self.searchFreeTime(
                    in: events,
                    from: from,
                    to: to,
                    startDate: startDate,
                    endDate: endDate,
                    freeTime: self.timeInterval(of: freeTime),
                    transitTime: self.timeInterval(of: transitTime)
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

    private func searchFreeTime(in events: [EventEntity], from: Date, to: Date, startDate: Date, endDate: Date, freeTime: TimeInterval, transitTime: TimeInterval) {
        let dates = calculator.split(from: from, to: to, startDate: startDate, endDate: endDate)
        let minFreeTime = freeTime + transitTime * 2
        
        var result: [(Date, Date)] = []
        dates.forEach { (start, end) in
            let eventsOfTheDay = events.search(in: start)
            if 0 == eventsOfTheDay.count {
                let timeInterval = abs(start.distance(to: end))
                if timeInterval >= minFreeTime {
                    result.append((start, end))
                }
            } else if 1 == eventsOfTheDay.count, let first = eventsOfTheDay.first {
                let startTimeIntervalOfTheDay = calculator.startTimeInterval(at: start, for: first)
                let endTimeIntervalOfTheDay = calculator.endTimeInterval(at: end, for: first)
                
                if startTimeIntervalOfTheDay >= minFreeTime {
                    result.append((start, first.startDate))
                }
                if endTimeIntervalOfTheDay >= minFreeTime {
                    result.append((first.endDate, end))
                }
            } else {
                eventsOfTheDay.enumerated().forEach { offset, event in
                    if offset == 0 {
                        let startTimeIntervalOfTheDay = calculator.startTimeInterval(at: start, for: event)
                        if startTimeIntervalOfTheDay >= minFreeTime {
                            result.append((start, event.startDate))
                        }
                    } else if offset == eventsOfTheDay.count - 1 {
                        let endTimeIntervalOfTheDay = calculator.endTimeInterval(at: end, for: event)
                        if endTimeIntervalOfTheDay >= minFreeTime {
                            result.append((event.endDate, end))
                        }
                    } else {
                        let preEvent = eventsOfTheDay[offset - 1]
                        let timeInterval = calculator.timeInterval(from: preEvent, to: event)
                        if timeInterval >= minFreeTime {
                            result.append((preEvent.endDate, event.startDate))
                        }
                    }
                }
            }
        }
        print(#function, "result \(result)")
    }
}
