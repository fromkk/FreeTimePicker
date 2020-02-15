//
//  EventDateCalculatorTests.swift
//  CoreTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import Core
import XCTest

final class EventDateCalculatorTests: XCTestCase {
    let calculator = EventDateCalculator()

    func testIsContains() {
        XCTContext.runActivity(named: "isContains entity and entity") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 30), isAllDay: false)
            let distEntity = EventEntity(title: "fuga", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 18, minute: 30), isAllDay: false)
            XCTAssertTrue(calculator.isContains(source: baseEntity, dist: distEntity))
        }

        XCTContext.runActivity(named: "!isContains entity and entity") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 18, minute: 30), isAllDay: false)
            let distEntity = EventEntity(title: "fuga", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 30), isAllDay: false)
            XCTAssertFalse(calculator.isContains(source: baseEntity, dist: distEntity))
        }

        XCTContext.runActivity(named: "isContains entity and date") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 30), isAllDay: false)
            let date = DateCreator.create(year: 2020, month: 2, day: 20, hour: 12, minute: 0)
            XCTAssertTrue(calculator.isContains(source: baseEntity, at: date))
        }

        XCTContext.runActivity(named: "!isContains entity and date") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 30), isAllDay: false)
            let date1 = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 29)
            let date2 = DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 31)
            XCTAssertFalse(calculator.isContains(source: baseEntity, at: date1))
            XCTAssertFalse(calculator.isContains(source: baseEntity, at: date2))
        }
    }
    func testIsIntersects() {
        XCTContext.runActivity(named: "isIntersects1") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 30), isAllDay: false)
            let distEntity = EventEntity(title: "fuga", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 18, minute: 30), isAllDay: false)
            XCTAssertTrue(calculator.isIntersects(source: baseEntity, dist: distEntity))
        }

        XCTContext.runActivity(named: "isIntersects2") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 30), isAllDay: false)
            let distEntity = EventEntity(title: "fuga", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 20, minute: 30), isAllDay: false)
            XCTAssertTrue(calculator.isIntersects(source: baseEntity, dist: distEntity))
        }

        XCTContext.runActivity(named: "isIntersects3") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 18, minute: 30), isAllDay: false)
            let distEntity = EventEntity(title: "fuga", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 30), isAllDay: false)
            XCTAssertTrue(calculator.isIntersects(source: baseEntity, dist: distEntity))
        }

        XCTContext.runActivity(named: "!isIntersects") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 18, minute: 30), isAllDay: false)
            let distEntity = EventEntity(title: "fuga", startDate: DateCreator.create(year: 2020, month: 2, day: 21, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 30), isAllDay: false)
            XCTAssertFalse(calculator.isIntersects(source: baseEntity, dist: distEntity))
        }
    }
    func testTimeInterval() {
        XCTContext.runActivity(named: "normal") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 30), isAllDay: false)
            let distEntity = EventEntity(title: "fuga", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 12, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 13, minute: 30), isAllDay: false)
            XCTAssertEqual(calculator.timeInterval(from: baseEntity, to: distEntity), 60 * 60)
        }

        XCTContext.runActivity(named: "reversed") { (_) in
            let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 12, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 13, minute: 30), isAllDay: false)
            let distEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 11, minute: 30), isAllDay: false)
            XCTAssertEqual(calculator.timeInterval(from: baseEntity, to: distEntity), 60 * 60)
        }
    }
    func testStartTimeInterval() {
        let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 12, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 13, minute: 30), isAllDay: false)
        let date = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 30)
        XCTAssertEqual(calculator.startTimeInterval(at: date, for: baseEntity), 60 * 60 * 2)
    }
    func testEndTimeInterval() {
        let baseEntity = EventEntity(title: "hoge", startDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 12, minute: 30), endDate: DateCreator.create(year: 2020, month: 2, day: 20, hour: 13, minute: 30), isAllDay: false)
        let date = DateCreator.create(year: 2020, month: 2, day: 20, hour: 15, minute: 30)
        XCTAssertEqual(calculator.endTimeInterval(at: date, for: baseEntity), 60 * 60 * 2)
    }
    func testConvert() {
        let date = DateCreator.create(year: 2020, month: 2, day: 1, hour: 9, minute: 0)
        let today = DateCreator.create(year: 2020, month: 2, day: 20, hour: 15, minute: 0)
        let result = calculator.convert(date, to: today)
        XCTAssertEqual(result, DateCreator.create(year: 2020, month: 2, day: 20, hour: 9, minute: 0))
    }
    func testSplit() {
        XCTContext.runActivity(named: "same day") { (_) in
            let from = DateCreator.create(year: 2020, month: 2, day: 20, hour: 0, minute: 0)
            let to = DateCreator.create(year: 2020, month: 2, day: 20, hour: 23, minute: 59)
            let start = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 0)
            let end = DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 0)
            let ((resultFrom, resultTo)) = calculator.split(from: from, to: to, startTime: start, endTime: end).first!
            XCTAssertEqual(resultFrom, start)
            XCTAssertEqual(resultTo, end)
        }

        XCTContext.runActivity(named: "difference day") { (_) in
            let from = DateCreator.create(year: 2020, month: 2, day: 1, hour: 0, minute: 0)
            let to = DateCreator.create(year: 2020, month: 2, day: 29, hour: 23, minute: 59)
            let start = DateCreator.create(year: 2020, month: 2, day: 20, hour: 10, minute: 0)
            let end = DateCreator.create(year: 2020, month: 2, day: 20, hour: 19, minute: 0)
            let result = calculator.split(from: from, to: to, startTime: start, endTime: end)
            XCTAssertEqual(result.count, 29)
            XCTAssertEqual(result.first!.0, DateCreator.create(year: 2020, month: 2, day: 1, hour: 10, minute: 0))
            XCTAssertEqual(result.first!.1, DateCreator.create(year: 2020, month: 2, day: 1, hour: 19, minute: 0))
            XCTAssertEqual(result.last!.0, DateCreator.create(year: 2020, month: 2, day: 29, hour: 10, minute: 0))
            XCTAssertEqual(result.last!.1, DateCreator.create(year: 2020, month: 2, day: 29, hour: 19, minute: 0))
        }
    }
}
