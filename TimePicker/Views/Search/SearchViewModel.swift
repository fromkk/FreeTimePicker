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
    @Published private var changeValue: Void? = nil
    
    private var cancellables: [AnyCancellable] = []

    init() {
        bind()
    }
    
    private func bind() {
        $searchDateType.filter { $0 != nil }.map { _ in () }.assign(to: \.changeValue, on: self).store(in: &cancellables)
        $minFreeTimeDate.filter { $0 != nil }.map { _ in () }.assign(to: \.changeValue, on: self).store(in: &cancellables)
        $fromTime.filter { $0 != nil }.map { _ in () }.assign(to: \.changeValue, on: self).store(in: &cancellables)
        $toTime.filter { $0 != nil }.map { _ in () }.assign(to: \.changeValue, on: self).store(in: &cancellables)
        $transitTimeDate.filter { $0 != nil }.map { _ in () }.assign(to: \.changeValue, on: self).store(in: &cancellables)
        $ignoreAllDays.map { _ in () }.assign(to: \.changeValue, on: self).store(in: &cancellables)
        
        $changeValue.filter { $0 != nil }.sink { [weak self] _ in
            self?.handleIsValid()
        }.store(in: &cancellables)
    }

    private func handleIsValid() {
        guard let _ = searchDateType, let _ = minFreeTimeDate, let _ = fromTime, let _ = toTime, let _ = transitTimeDate else {
            isValid = false
            return
        }
        isValid = true
    }

    func search() {
        guard let searchDateType = searchDateType, let minFreeTime = minFreeTimeDate, let fromTime = fromTime, let toTime = toTime, let transitTime = transitTimeDate else {
            return
        }
        print("search")
    }
}
