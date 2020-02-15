//
//  FreeTimeConverterTests.swift
//  CoreTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import Core
import XCTest

final class FreeTimeConverterTests: XCTestCase {
    func testToString() {
        let from = DateCreator.create(year: 2020, month: 2, day: 20, hour: 15, minute: 30)
        let to = DateCreator.create(year: 2020, month: 2, day: 20, hour: 17, minute: 0)
        let string = FreeTimeConverter(dates: [(from, to)]).toString()
        if Locale.current.regionCode == "JP", Locale.current.languageCode == "ja" {
            XCTAssertEqual(string, "2020年2月20日(木) 15:30〜2020年2月20日(木) 17:00")
        } else if Locale.current.regionCode == "US", Locale.current.languageCode == "en" {
            XCTAssertEqual(string, "Thu, Feb 20, 2020, 3:30 PM - Thu, Feb 20, 2020, 5:00 PM")
        }
    }
}
