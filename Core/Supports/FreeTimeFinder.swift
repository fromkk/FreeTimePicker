//
//  FreeTimeFinder.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

public final class FreeTimeFinder {
    public typealias Result = [(Date, Date)]
    public static func find(with calculator: EventDateCalculator, in events: [EventEntity], from: Date, to: Date, startTime: Date, endTime: Date, freeTime: TimeInterval, transitTime: TimeInterval, ignoreAllDay: Bool, ignoreHolidays: Bool) -> Result {
        let dates = calculator.split(from: from, to: to, startTime: startTime, endTime: endTime)
        let minFreeTime = freeTime + transitTime * 2

        var result: Result = []
        dates.forEach { (start, end) in
            var todaysResult: Result = []
            defer {
                if todaysResult.count == 0 {
                    todaysResult.append((start, end))
                }
                result.append(contentsOf: todaysResult)
            }
            
            if ignoreHolidays, start.isHoliday() {
                return
            }

            let eventsOfTheDay = events.search(in: start, and: end)
            if 0 == eventsOfTheDay.count {
                let timeInterval = abs(start.distance(to: end))
                if timeInterval >= minFreeTime {
                    todaysResult.append((start, end))
                }
            } else if 1 == eventsOfTheDay.count, let first = eventsOfTheDay.first {
                if ignoreAllDay, first.isAllDay {
                    return
                }

                self.first(with: calculator, at: start, with: first, minFreeTime: minFreeTime, in: &todaysResult)
                self.end(with: calculator, at: end, with: first, minFreeTime: minFreeTime, in: &todaysResult)
            } else {
                eventsOfTheDay.enumerated().forEach { offset, event in
                    if ignoreAllDay, event.isAllDay {
                        return
                    }

                    if offset == 0 {
                        self.first(with: calculator, at: start, with: event, minFreeTime: minFreeTime, in: &todaysResult)
                    } else {
                        let preEvent = eventsOfTheDay[offset - 1]
                        self.between(with: calculator, preEvent: preEvent, currentEvent: event, minFreeTime: minFreeTime, in: &todaysResult)
                    }
                    if offset == eventsOfTheDay.count - 1 {
                        self.end(with: calculator, at: end, with: event, minFreeTime: minFreeTime, in: &todaysResult)
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
