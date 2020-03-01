//
//  XCTestCase+extensions.swift
//  FreeTimePickerUITests
//
//  Created by Kazuya Ueoka on 2020/02/29.
//  Copyright © 2020 fromKK. All rights reserved.
//

import XCTest

extension XCTestCase {
    func takeScreenShot(_ name: String) {
        XCTContext.runActivity(named: name) { activity in
            let screenShot = XCUIScreen.main.screenshot()
            let attachment = XCTAttachment(screenshot: screenShot)
            attachment.lifetime = .keepAlways
            activity.add(attachment)
        }
    }
}
