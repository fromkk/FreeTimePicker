//
//  SearchDateTests.swift
//  FreeTimePickerTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import FreeTimePicker
import XCTest
import Core

final class SearchDateTests: XCTestCase {
    func testTap() {
        let spy = SearchDateDelegateSpy()
        let searchDate = SearchDate()
        searchDate.delegate = spy
        let button = searchDate.buttons[1]
        
        XCTAssertNil(searchDate.selectedSearchDateType)
        XCTAssertFalse(spy.invokedSearchDate)
        searchDate.tap(button: button)
        XCTAssertEqual(searchDate.selectedSearchDateType, .tomorrow)
        XCTAssertTrue(spy.invokedSearchDate)
    }
}
