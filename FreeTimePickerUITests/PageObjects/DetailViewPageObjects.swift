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

    func closeShareView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            application.tap()
        } else {
            let closeLabel: String = {
                if Locale.current.languageCode == "ja" {
                    return "閉じる"
                } else {
                    return "Close"
                }
            }()
            let button: XCUIElement = application.buttons.allElementsBoundByIndex.filter { button in
                return button.label == closeLabel
            }.last!
            button.tap()
        }
    }
}
