//
//  ToolbarTests.swift
//  FreeTimePickerTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import Pity
import XCTest
import Combine

final class ToolbarTests: XCTestCase {
    private var cancellables: [AnyCancellable] = []

    func testCompletion() {
        let toolbar = Toolbar()
        let expectation = self.expectation(description: "wait completion")
        toolbar.completion.sink {
            expectation.fulfill()
        }.store(in: &cancellables)
        toolbar.tap(completionButton: toolbar.completionButton)
        wait(for: [expectation], timeout: 0.1)
    }
}
