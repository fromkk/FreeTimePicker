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
    func testConvert() {}
    func testSplit() {}
}
