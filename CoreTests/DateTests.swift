//
//  DateTests.swift
//  CoreTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import Core
import XCTest

final class DateTests: XCTestCase {
    func testIsHoliday() {
        let sunday = DateCreator.create(year: 2020, month: 2, day: 9, hour: 10, minute: 0)
        XCTAssertTrue(sunday.isHoliday())
        let saturday = DateCreator.create(year: 2020, month: 2, day: 15, hour: 10, minute: 0)
        XCTAssertTrue(saturday.isHoliday())
        let wednesday = DateCreator.create(year: 2020, month: 2, day: 12, hour: 10, minute: 0)
        XCTAssertFalse(wednesday.isHoliday())
    }
}
