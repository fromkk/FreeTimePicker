//
//  FreeTimeFinder.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

final class FreeTimeFinder {
    typealias Result = [(Date, Date)]
    static func find(with calculator: EventDateCalculator, in events: [EventEntity], from: Date, to: Date, startDate: Date, endDate: Date, freeTime: TimeInterval, transitTime: TimeInterval) -> Result {
        let dates = calculator.split(from: from, to: to, startDate: startDate, endDate: endDate)
        let minFreeTime = freeTime + transitTime * 2

        var result: Result = []
        dates.forEach { (start, end) in
            let eventsOfTheDay = events.search(in: start, and: end)
            if 0 == eventsOfTheDay.count {
                let timeInterval = abs(start.distance(to: end))
                if timeInterval >= minFreeTime {
                    result.append((start, end))
                }
            } else if 1 == eventsOfTheDay.count, let first = eventsOfTheDay.first {
                self.first(with: calculator, at: start, with: first, minFreeTime: minFreeTime, in: &result)
                self.end(with: calculator, at: end, with: first, minFreeTime: minFreeTime, in: &result)
            } else {
                eventsOfTheDay.enumerated().forEach { offset, event in
                    if offset == 0 {
                        self.first(with: calculator, at: start, with: event, minFreeTime: minFreeTime, in: &result)
                    } else if offset == eventsOfTheDay.count - 1 {
                        self.end(with: calculator, at: start, with: event, minFreeTime: minFreeTime, in: &result)
                    } else {
                        let preEvent = eventsOfTheDay[offset - 1]
                        self.between(with: calculator, preEvent: preEvent, currentEvent: event, minFreeTime: minFreeTime, in: &result)
                    }
                }
            }
        }
        return result.map { adjust(dates: $0, withTransit: transitTime) }
    }

    private static func first(with calculator: EventDateCalculator, at date: Date, with event: EventEntity, minFreeTime: TimeInterval, in result: inout Result) {
        let startTimeIntervalOfTheDay = calculator.startTimeInterval(at: date, for: event)
        if startTimeIntervalOfTheDay >= minFreeTime {
            result.append((date, event.startDate))
        }
    }

    private static func end(with calculator: EventDateCalculator, at date: Date, with event: EventEntity, minFreeTime: TimeInterval, in result: inout Result) {
        let endTimeIntervalOfTheDay = calculator.endTimeInterval(at: date, for: event)
        if endTimeIntervalOfTheDay >= minFreeTime {
            result.append((event.endDate, date))
        }
    }

    private static func between(with calculator: EventDateCalculator, preEvent: EventEntity, currentEvent: EventEntity, minFreeTime: TimeInterval, in result: inout Result) {
        let timeInterval = calculator.timeInterval(from: preEvent, to: currentEvent)
        if timeInterval >= minFreeTime {
            result.append((preEvent.endDate, currentEvent.startDate))
        }
    }

    private static func adjust(dates: (Date, Date), withTransit transitTime: TimeInterval) -> (Date, Date) {
        return (
            dates.0.addingTimeInterval(transitTime),
            dates.1.addingTimeInterval(-transitTime)
        )
    }
}
