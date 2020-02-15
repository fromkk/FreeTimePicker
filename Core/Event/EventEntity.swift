//
//  EventEntity.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/11.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

public struct EventEntity {
    public let title: String
    public let startDate: Date
    public let endDate: Date
    public let isAllDay: Bool
}

extension Collection where Element == EventEntity {
    public func search(in startDate: Date, and endDate: Date) -> [EventEntity] {
        filter { entity in
            if startDate <= entity.startDate, endDate >= entity.endDate {
                return true
            } else if startDate >= entity.startDate, endDate <= entity.endDate {
                return true
            } else {
                return false
            }
        }
    }
}
