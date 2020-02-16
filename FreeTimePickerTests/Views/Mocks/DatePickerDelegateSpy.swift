//
//  DatePickerDelegateSpy.swift
//  FreeTimePickerTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import Piem

final class DatePickerDelegateSpy: DatePickerDelegate {
    var invokedDatePickerDidChanged = false
    var invokedDatePickerDidChangedCount = 0
    var invokedDatePickerDidChangedParameters: (datePicker: DatePicker, Void)?
    var invokedDatePickerDidChangedParametersList = [(datePicker: DatePicker, Void)]()
    func datePickerDidChanged(_ datePicker: DatePicker) {
        invokedDatePickerDidChanged = true
        invokedDatePickerDidChangedCount += 1
        invokedDatePickerDidChangedParameters = (datePicker, ())
        invokedDatePickerDidChangedParametersList.append((datePicker, ()))
    }
}
