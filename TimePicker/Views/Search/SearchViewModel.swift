//
//  SearchViewModel.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {
    @Published var isValid: Bool = false
    @Published var searchDateType: SearchDateType? = nil
    @Published var minFreeTimeDate: Date? = nil
    @Published var minFreeTimeText: String? = nil
    @Published var fromTime: Date? = nil
    @Published var fromText: String? = nil
    @Published var toTime: Date? = nil
    @Published var toText: String? = nil
    @Published var transitTimeDate: Date? = nil
    @Published var transitTimeText: String? = nil
    @Published var ignoreAllDays: Bool = true
    private var _search: PassthroughSubject<Void?, Never> = .init()
    
    private var cancellables: [AnyCancellable] = []

    typealias Range = (Date?, Date?)
    
    let eventRepository: EventRepositoryProtocol

    init(eventRepository: EventRepositoryProtocol) {
        self.eventRepository = eventRepository
        bind()
    }
    
    private func bind() {
        let fromTo = Publishers.CombineLatest($fromTime, $toTime)
        let freeTimeAndTransitTime = Publishers.CombineLatest($minFreeTimeDate, $transitTimeDate)
        let combine = Publishers.CombineLatest4($searchDateType, fromTo, freeTimeAndTransitTime, $ignoreAllDays).share()
        combine.sink { [weak self] searchDateType, fromTo, freeTimeAndTransitTime, ignoreAllDays in
                self?.handleIsValid(searchDateType: searchDateType, fromTo: fromTo, freeTimeAndTransitTime: freeTimeAndTransitTime, ignoreAllDays: ignoreAllDays)
            }.store(in: &cancellables)

        _search.filter { $0 != nil }
            .zip(combine, { $1 })
                .sink { [weak self] searchDateType, fromTo, freeTimeAndTransitTime, ignoreAllDays in
                    guard let searchDateType = searchDateType else { return }
                    self?.performSearch(searchDateType: searchDateType, fromTo: fromTo, freeTimeAndTransitTime: freeTimeAndTransitTime, ignoreAllDays: ignoreAllDays)
            }.store(in: &cancellables)
    }

    func search() {
        _search.send(())
        _search.send(nil)
    }

    private func handleIsValid(searchDateType: SearchDateType?, fromTo: Range, freeTimeAndTransitTime: Range, ignoreAllDays: Bool) {
        let isValidFromTo: Bool = {
            if let from = fromTo.0, let to = fromTo.1 {
                return from < to
            } else {
                return false
            }
        }()

        isValid = searchDateType != nil && isValidFromTo && freeTimeAndTransitTime.0 != nil && freeTimeAndTransitTime.1 != nil
    }

    private func performSearch(searchDateType: SearchDateType, fromTo: Range, freeTimeAndTransitTime: Range, ignoreAllDays: Bool) {
        let (startDate, endDate) = searchDateType.dates()
        eventRepository.fetch(startDate: startDate, endDate: endDate, ignoreAllDay: ignoreAllDays)
            .sink { events in
                print(events)
        }.store(in: &cancellables)
    }
}
