//
//  EventEntity.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/11.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

struct EventEntity {
    let title: String
    let startDate: Date
    let endDate: Date
    let isAllDay: Bool
}

extension Collection where Element == EventEntity {
    func search(in startDate: Date, and endDate: Date) -> [EventEntity] {
        return filter { entity in
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
