//
//  TimePickerUITests.swift
//  TimePickerUITests
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import XCTest

class TimePickerUITests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
        let app = XCUIApplication()
        app.launch()
        handleCalendarPermission()
    }

    private func handleCalendarPermission() {
        let calendarPermissionMonitor = addUIInterruptionMonitor(withDescription: "Calendar access") { (alert) -> Bool in
            if alert.buttons["OK"].exists {
                alert.buttons["OK"].tap()
                return true
            }
            return false
        }
        XCUIApplication().tap()
        removeUIInterruptionMonitor(calendarPermissionMonitor)
    }

    func testSearch() {
        takeScreenShot("launch")
        let application = XCUIApplication()
        if application.buttons["completionButton"].exists {
            application.buttons["completionButton"].tap()
        }

        let searchView = SearchViewPageObjects(application: application)
        searchView.tapNextWeek()
        takeScreenShot("tapNextWeek")
        searchView.tapSearchButton()

        let detailView = DetailViewPageObjects(application: application)
        takeScreenShot("detailView")
        detailView.tapShareButton()
        takeScreenShot("share")
        application.tap()
        detailView.tapCloseButton()

        searchView.tapToday()
        searchView.tapSearchButton()
    }
}
