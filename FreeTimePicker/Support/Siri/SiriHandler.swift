//
//  SiriHandler.swift
//  FreeTimePicker
//
//  Created by Kazuya Ueoka on 2020/02/16.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import Core
import Foundation
import Intents

final class SiriHandler: ObservableObject {
    weak var searchViewModel: SearchViewModel? {
        didSet {
            guard let searchDateType = searchDateType else { return }
            performSearch(searchDateType)
        }
    }

    @Published var searchDateType: SearchDateType?
    private var cancellables: [AnyCancellable] = []

    init() {
        bind()
    }

    private func bind() {
        $searchDateType.sink { [weak self] searchDateType in
            guard let searchDateType = searchDateType else { return }
            self?.performSearch(searchDateType)
        }.store(in: &cancellables)
    }

    private func performSearch(_ searchDateType: SearchDateType) {
        searchViewModel?.searchDateType = searchDateType
        searchViewModel?.search()
    }
}
