//
//  SearchDateDelegateSpy.swift
//  FreeTimePickerTests
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

@testable import Piem
import Core

final class SearchDateDelegateSpy: SearchDateDelegate {
    var invokedSearchDate = false
    var invokedSearchDateCount = 0
    var invokedSearchDateParameters: (searchDate: SearchDate, dateType: SearchDateType)?
    var invokedSearchDateParametersList = [(searchDate: SearchDate, dateType: SearchDateType)]()
    func searchDate(_ searchDate: SearchDate, didSelect dateType: SearchDateType) {
        invokedSearchDate = true
        invokedSearchDateCount += 1
        invokedSearchDateParameters = (searchDate, dateType)
        invokedSearchDateParametersList.append((searchDate, dateType))
    }
}
