//
//  EventDateCalculator.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

public final class EventDateCalculator {
    public init() {}

    public func isContains(source sourceEventEntity: EventEntity, dist distEventEntity: EventEntity) -> Bool {
        return isContains(source: sourceEventEntity, at: distEventEntity.startDate)
        && isContains(source: sourceEventEntity, at: distEventEntity.endDate)
    }

    public func isIntersects(source sourceEventEntity: EventEntity, dist distEventEntity: EventEntity) -> Bool {
        return isContains(source: sourceEventEntity, at: distEventEntity.startDate)
            || isContains(source: sourceEventEntity, at: distEventEntity.endDate)
    }

    public func isContains(source eventEntity: EventEntity, at date: Date) -> Bool {
        return eventEntity.startDate <= date && eventEntity.endDate >= date
    }

    public func timeInterval(from fromEventEntity: EventEntity, to toEventEntity: EventEntity) -> TimeInterval {
        if fromEventEntity.endDate <= toEventEntity.startDate {
            return fromEventEntity.endDate.distance(to: toEventEntity.startDate)
        } else {
            return toEventEntity.endDate.distance(to: fromEventEntity.startDate)
        }
    }

    public func startTimeInterval(at date: Date, for eventEntity: EventEntity) -> TimeInterval {
        return date.distance(to: eventEntity.startDate)
    }

    public func endTimeInterval(at date: Date, for eventEntity: EventEntity) -> TimeInterval {
        return eventEntity.endDate.distance(to: date)
    }
    
    public func convert(_ date: Date, to today: Date, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        var dateComponentsSrc = calendar.dateComponents([.hour, .minute], from: date)
        dateComponentsSrc.calendar = calendar
        dateComponentsSrc.timeZone = timeZone
        
        var dateComponentsDist = calendar.dateComponents([.year, .month, .day], from: today)
        dateComponentsDist.calendar = calendar
        dateComponentsDist.timeZone = timeZone
        dateComponentsDist.hour = dateComponentsSrc.hour
        dateComponentsDist.minute = dateComponentsSrc.minute
        dateComponentsDist.second = 0
        dateComponentsDist.nanosecond = 0
        
        return calendar.date(from: dateComponentsDist)!
    }
    
    public func split(from fromDate: Date, to toDate: Date, startDate: Date, endDate: Date, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> [(Date, Date)] {
        var calendar = calendar
        calendar.timeZone = timeZone
        var fromDateComponents = calendar.dateComponents([.year, .month, .day], from: fromDate)
        fromDateComponents.timeZone = timeZone
        
        var toDateComponents = calendar.dateComponents([.year, .month, .day], from: toDate)
        toDateComponents.timeZone = timeZone
        let toDateForCompare = calendar.date(from: toDateComponents)!
        
        var currentDateComponents = fromDateComponents
        var appendDateComponents = DateComponents()
        appendDateComponents.day = 1
        
        var result: [(Date, Date)] = []
        repeat {
            let date = calendar.date(from: currentDateComponents)!
            let from = convert(startDate, to: date)
            let to = convert(endDate, to: date)
            result.append((from, to))
            
            let nextDate = calendar.date(byAdding: appendDateComponents, to: date)!
            currentDateComponents = calendar.dateComponents([.year, .month, .day], from: nextDate)
            currentDateComponents.timeZone = timeZone
        } while calendar.date(from: currentDateComponents)! <= toDateForCompare
        return result
    }
}
