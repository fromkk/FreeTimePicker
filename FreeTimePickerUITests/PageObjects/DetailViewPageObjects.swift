//
//  DetailViewPageObjects.swift
//  FreeTimePickerUITests
//
//  Created by Kazuya Ueoka on 2020/02/29.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation
import XCTest

struct DetailViewPageObjects: PageObjectRepresentable {
    private let application: XCUIApplication
    init(application: XCUIApplication) {
        self.application = application
    }

    var closeButton: XCUIElement {
        return application.buttons["closeButton"]
    }

    func tapCloseButton() {
        closeButton.tap()
    }

    var shareButton: XCUIElement {
        return application.buttons["shareButton"]
    }

    func tapShareButton() {
        shareButton.tap()
    }

    var textView: XCUIElement {
        return application.textViews["textView"]
    }
}
