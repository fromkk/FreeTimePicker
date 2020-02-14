//
//  DatePickerTests.swift
//  FreeTimePickerTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import FreeTimePicker
import XCTest

final class DatePickerTests: XCTestCase {
    private func makeDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        dateComponents.nanosecond = 0
        return calendar.date(from: dateComponents)!
    }
    
    private func time(date: Date, calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> (Int, Int) {
        var calendar = calendar
        calendar.timeZone = timeZone
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        return (dateComponents.hour!, dateComponents.minute!)
    }
    
    func testSetDate() {
        let datePicker = DatePicker(datePickerMode: .time)
        let delegate = DatePickerDelegateSpy()
        datePicker.datePickerDelegate = delegate
        
        XCTAssertFalse(delegate.invokedDatePickerDidChanged)
        datePicker.date = makeDate(year: 2020, month: 2, day: 20, hour: 10, minute: 30, second: 0)
        XCTAssertTrue(delegate.invokedDatePickerDidChanged)
        XCTAssertEqual(datePicker.text, "10:30")
    }
    
    func testSetText() {
        let datePicker = DatePicker(datePickerMode: .time)
        let delegate = DatePickerDelegateSpy()
        datePicker.datePickerDelegate = delegate
        
        XCTAssertFalse(delegate.invokedDatePickerDidChanged)
        datePicker.text = "11:45"
        let (hour, minute) = time(date: datePicker.date!)
        XCTAssertEqual(hour, 11)
        XCTAssertEqual(minute, 45)
        XCTAssertTrue(delegate.invokedDatePickerDidChanged)
    }
}
