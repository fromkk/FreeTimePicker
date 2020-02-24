//
//  EventRepositorySpy.swift
//  FreeTimePicker
//
//  Created by Kazuya Ueoka on 2020/02/24.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import Core
import Foundation

#if DEBUG
    final class EventRepositorySpy: EventRepositoryProtocol {
        var invokedFetch = false
        var invokedFetchCount = 0
        var invokedFetchParameters: (startDate: Date, endDate: Date, ignoreAllDay: Bool)?
        var invokedFetchParametersList = [(startDate: Date, endDate: Date, ignoreAllDay: Bool)]()
        var stubbedFetchResult: AnyPublisher<[EventEntity], Never>!
        func fetch(startDate: Date, endDate: Date, ignoreAllDay: Bool) -> AnyPublisher<[EventEntity], Never> {
            invokedFetch = true
            invokedFetchCount += 1
            invokedFetchParameters = (startDate, endDate, ignoreAllDay)
            invokedFetchParametersList.append((startDate, endDate, ignoreAllDay))
            return stubbedFetchResult
        }
    }
#endif
