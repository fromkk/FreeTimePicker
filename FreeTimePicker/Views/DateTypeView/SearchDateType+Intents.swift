//
//  SearchDateType+Intents.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation
import Intents

extension SearchDateType {
    func toDateType() -> DateType {
        switch self {
        case .today:
            return .today
        case .tomorrow:
            return .tomorrow
        case .thisWeek:
            return .thisWeek
        case .nextWeek:
            return .nextWeek
        case .thisMonth:
            return .thisMonth
        case .nextMonth:
            return .nextMonth
        }
    }
}

extension DateType {
    func toSearchDateType() -> SearchDateType? {
        switch self {
        case .today:
            return .today
        case .tomorrow:
            return .tomorrow
        case .thisWeek:
            return .thisWeek
        case .nextWeek:
            return .nextWeek
        case .thisMonth:
            return .thisMonth
        case .nextMonth:
            return .nextMonth
        case .unknown:
            return nil
        }
    }
}
