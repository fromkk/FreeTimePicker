//
//  DetailViewModel.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

final class DetailViewModel: ObservableObject {
    let separator = NSLocalizedString(" - ", comment: " - ")
    var dateFormat: String = {
        let defaultDateFormat = "EEE, d MMM yyyy, HH:mm"
        let userDefaultsFormat = UserDefaults.standard.string(forKey: "date_format")
        return DateFormatter.dateFormat(fromTemplate: userDefaultsFormat ?? defaultDateFormat, options: 0, locale: .current) ?? defaultDateFormat
    }()

    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .init(identifier: .gregorian)
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        return dateFormatter
    }()

    var dates: [(Date, Date)]
    init(dates: [(Date, Date)]) {
        self.dates = dates
        toString()
    }

    private func toString() {
        dateFormatter.dateFormat = dateFormat
        text = dates.map {
            let from = dateFormatter.string(from: $0)
            let to = dateFormatter.string(from: $1)
            return String(format: "%@%@%@", from, separator, to)
        }.joined(separator: "\n")
    }
    
    @Published var text: String = ""
}
