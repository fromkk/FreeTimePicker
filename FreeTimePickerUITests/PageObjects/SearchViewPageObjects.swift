//
//  SearchViewPageObjects.swift
//  FreeTimePickerUITests
//
//  Created by Kazuya Ueoka on 2020/02/29.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation
import XCTest

struct SearchViewPageObjects: PageObjectRepresentable {
    private let application: XCUIApplication
    init(application: XCUIApplication) {
        self.application = application
    }

    var searchDateView: XCUIElement {
        return application
            .otherElements["searchFormView"]
    }

    var minFreeTime: XCUIElement {
        return application.textFields["minFreeTimeDatePicker"]
    }

    var fromTimePickerView: XCUIElement {
        return application.textFields["fromTimePickerView"]
    }

    var toTimePickerView: XCUIElement {
        return application.textFields["toTimePickerView"]
    }

    var searchButton: XCUIElement {
        return application.buttons["searchButton"]
    }

    func tapToday() {
        searchDateView.buttons["todayButton"].tap()
    }

    func tapNextWeek() {
        searchDateView.buttons["nextWeekButton"].tap()
    }

    func tapSearchButton() {
        searchButton.tap()
    }
}
