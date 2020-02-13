//
//  EventRepository.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/11.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation
import Combine
import EventKit

public protocol EventRepositoryProtocol {
    func fetch(startDate: Date, endDate: Date, ignoreAllDay: Bool) -> AnyPublisher<[EventEntity], Never>
}

public final class EventRepository: EventRepositoryProtocol {
    public init() {}

    public func fetch(startDate: Date, endDate: Date, ignoreAllDay: Bool) -> AnyPublisher<[EventEntity], Never> {
        return Deferred {
            Future<[EventEntity], Never> { promise in
                DispatchQueue.global(qos: .userInitiated).async {
                    let store = EKEventStore()
                    let calendars = store.calendars(for: .event)
                    let predicate = store.predicateForEvents(withStart: startDate, end: endDate, calendars: calendars)
                    let events: [EventEntity] = store.events(matching: predicate).compactMap { event -> EventEntity? in
                        let result = EventEntity(title: event.title, startDate: event.startDate, endDate: event.endDate, isAllDay: event.isAllDay)
                        if ignoreAllDay {
                            if !event.isAllDay {
                                return result
                            } else {
                                return nil
                            }
                        } else {
                            return result
                        }
                    }
                    promise(.success(events.sorted(by: { $0.startDate < $1.startDate })))
                }
            }.receive(on: DispatchQueue.main)
        }.eraseToAnyPublisher()
    }
}
