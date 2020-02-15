//
//  FreeTimeFinderTests.swift
//  CoreTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import Core
import XCTest

final class FreeTimeFinderTests: XCTestCase {
    func testFind() {
        XCTContext.runActivity(named: "one event one day, no transit time") { (_) in
            let calculator = EventDateCalculator()
            let entities: [EventEntity] = [
                .init(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 15, minute: 0), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 16, minute: 0), isAllDay: false)
            ]
            let from = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 0)
            let to = DateCreator.create(year: 2020, month: 2, day: 20, hour: 20, minute: 0)
            let result = FreeTimeFinder.find(with: calculator, in: entities, from: from, to: to, startTime: from, endTime: to, freeTime: 60 * 60, transitTime: 0, ignoreAllDay: false, ignoreHolidays: true)
            XCTAssertEqual(result.count, 2)
            XCTAssertEqual(result[0].0, from)
            XCTAssertEqual(result[0].1, entities[0].startDate)
            XCTAssertEqual(result[1].0, entities[0].endDate)
            XCTAssertEqual(result[1].1, to)
        }

        XCTContext.runActivity(named: "two events one day, no transit time") { (_) in
            let calculator = EventDateCalculator()
            let entities: [EventEntity] = [
                .init(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 0), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 12, minute: 0), isAllDay: false),
                .init(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 15, minute: 0), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 16, minute: 0), isAllDay: false)
            ]
            let from = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 0)
            let to = DateCreator.create(year: 2020, month: 2, day: 20, hour: 20, minute: 0)
            let result = FreeTimeFinder.find(with: calculator, in: entities, from: from, to: to, startTime: from, endTime: to, freeTime: 60 * 60, transitTime: 0, ignoreAllDay: false, ignoreHolidays: true)
            XCTAssertEqual(result.count, 3)
            XCTAssertEqual(result[0].0, from)
            XCTAssertEqual(result[0].1, entities[0].startDate)
            XCTAssertEqual(result[1].0, entities[0].endDate)
            XCTAssertEqual(result[1].1, entities[1].startDate)
            XCTAssertEqual(result[2].0, entities[1].endDate)
            XCTAssertEqual(result[2].1, to)
        }

        XCTContext.runActivity(named: "one event one day, has transit time") { (_) in
            let calculator = EventDateCalculator()
            let entities: [EventEntity] = [
                .init(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 15, minute: 0), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 16, minute: 0), isAllDay: false)
            ]
            let from = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 0)
            let to = DateCreator.create(year: 2020, month: 2, day: 20, hour: 20, minute: 0)
            let transitTime: TimeInterval = 30 * 60
            let result = FreeTimeFinder.find(with: calculator, in: entities, from: from, to: to, startTime: from, endTime: to, freeTime: 60 * 60, transitTime: transitTime, ignoreAllDay: false, ignoreHolidays: true)
            XCTAssertEqual(result.count, 2)
            XCTAssertEqual(result[0].0, from.addingTimeInterval(transitTime))
            XCTAssertEqual(result[0].1, entities[0].startDate.addingTimeInterval(-transitTime))
            XCTAssertEqual(result[1].0, entities[0].endDate.addingTimeInterval(transitTime))
            XCTAssertEqual(result[1].1, to.addingTimeInterval(-transitTime))
        }

        XCTContext.runActivity(named: "two events one day, has transit time") { (_) in
            let calculator = EventDateCalculator()
            let entities: [EventEntity] = [
                .init(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 0), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 12, minute: 0), isAllDay: false),
                .init(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 15, minute: 0), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 16, minute: 0), isAllDay: false)
            ]
            let from = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 0)
            let to = DateCreator.create(year: 2020, month: 2, day: 20, hour: 20, minute: 0)
            let transitTime: TimeInterval = 30 * 60
            let result = FreeTimeFinder.find(with: calculator, in: entities, from: from, to: to, startTime: from, endTime: to, freeTime: 60 * 60, transitTime: transitTime, ignoreAllDay: false, ignoreHolidays: true)
            XCTAssertEqual(result.count, 2)
            XCTAssertEqual(result[0].0, entities[0].endDate.addingTimeInterval(transitTime))
            XCTAssertEqual(result[0].1, entities[1].startDate.addingTimeInterval(-transitTime))
            XCTAssertEqual(result[1].0, entities[1].endDate.addingTimeInterval(transitTime))
            XCTAssertEqual(result[1].1, to.addingTimeInterval(-transitTime))
        }

        XCTContext.runActivity(named: "ignoreAllDay") { (_) in
            let calculator = EventDateCalculator()
            let entities: [EventEntity] = [
                .init(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 15, minute: 0), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 16, minute: 0), isAllDay: true)
            ]
            let from = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 0)
            let to = DateCreator.create(year: 2020, month: 2, day: 20, hour: 20, minute: 0)
            let result = FreeTimeFinder.find(with: calculator, in: entities, from: from, to: to, startTime: from, endTime: to, freeTime: 60 * 60, transitTime: 0, ignoreAllDay: true, ignoreHolidays: false)
            XCTAssertEqual(result.count, 0)
        }

        XCTContext.runActivity(named: "ignoreHoliday") { (_) in
            let calculator = EventDateCalculator()
            let entities: [EventEntity] = [
                .init(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 22, hour: 15, minute: 0), endDate: DateCreator.create(year: 2020, month: 2, day: 22, hour: 16, minute: 0), isAllDay: true)
            ]
            let from = DateCreator.create(year: 2020, month: 2, day: 22, hour: 10, minute: 0)
            let to = DateCreator.create(year: 2020, month: 2, day: 22, hour: 20, minute: 0)
            let result = FreeTimeFinder.find(with: calculator, in: entities, from: from, to: to, startTime: from, endTime: to, freeTime: 60 * 60, transitTime: 0, ignoreAllDay: true, ignoreHolidays: true)
            XCTAssertEqual(result.count, 0)
        }
    }
}
