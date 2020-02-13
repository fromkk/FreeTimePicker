//
//  SiriTests.swift
//  FreeTimePickerUITests
//
//  Created by Kazuya Ueoka on 2020/02/13.
//  Copyright © 2020 fromKK. All rights reserved.
//

import XCTest

final class SiriTests: XCTestCase {
    let application: XCUIApplication = .init()
    func testActive() {
        XCUIDevice.shared.siriService.activate(voiceRecognitionText: "Free Time Pickerで明日を探す")
    }
    
    func testInactive() {
        
    }
}
