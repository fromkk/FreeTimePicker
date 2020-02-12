//
//  DateTypeView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import SwiftUI
import UIKit
import Combine
import UI

enum SearchDateType: CaseIterable, Identifiable, Equatable {
    case today
    case tomorrow
    case thisWeek
    case nextWeek
    case thisMonth
    case nextMonth

    var title: String {
        let key: String
        switch self {
        case .today:
            key = "Search date today"
        case .tomorrow:
            key = "Search date tomorrow"
        case .thisWeek:
            key = "Search date this week"
        case .nextWeek:
            key = "Search date next week"
        case .thisMonth:
            key = "Search date this month"
        case .nextMonth:
            key = "Search date next month"
        }
        return NSLocalizedString(key, comment: key)
    }
    
    typealias Dates = (startDate: Date, endDate: Date)
    
    func dates(with date: Date = Date(), calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current, locale: Locale = .current) -> Dates {
        var calendar = calendar
        calendar.timeZone = timeZone
        calendar.locale = locale

        switch self {
        case .today:
            return today(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .tomorrow:
            return tomorrow(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .thisWeek:
            return thisWeek(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .nextWeek:
            return nextWeek(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .thisMonth:
            return thisMonth(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        case .nextMonth:
            return nextMonth(with: date, calendar: calendar, timeZone: timeZone, locale: locale)
        }
    }

    private func today(with date: Date, calendar: Calendar, timeZone: TimeZone, locale: Locale) -> Dates {
        let startDate = calendar.startOfDay(for: date)
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.day = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (startDate, endDate)
    }

    private func tomorrow(with date: Date, calendar: Calendar, timeZone: TimeZone, locale: Locale) -> Dates {
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.day = 1
        let tomorrow = calendar.date(byAdding: dateComponents, to: date)!
        let startDate = calendar.startOfDay(for: tomorrow)
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (startDate, endDate)
    }
    
    private func thisWeek(with date: Date, calendar: Calendar, timeZone: TimeZone, locale: Locale) -> Dates {
        var dateComponents = calendar.dateComponents([.year, .month, .weekOfMonth], from: date)
        dateComponents.weekday = 1
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        let startDate = calendar.date(from: dateComponents)!
        dateComponents = .init()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.weekOfMonth = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (calendar.startOfDay(for: date), endDate)
    }
    
    private func nextWeek(with date: Date, calendar: Calendar, timeZone: TimeZone, locale: Locale) -> Dates {
        var dateComponents = calendar.dateComponents([.year, .month, .weekOfMonth], from: date)
        dateComponents.weekday = 1
        dateComponents.weekOfMonth! += 1
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        let startDate = calendar.date(from: dateComponents)!
        dateComponents = .init()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.weekOfMonth = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (startDate, endDate)
    }
    
    private func thisMonth(with date: Date, calendar: Calendar, timeZone: TimeZone, locale: Locale) -> Dates {
        var dateComponents = calendar.dateComponents([.year, .month], from: date)
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        let startDate = calendar.date(from: dateComponents)!
        dateComponents = .init()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.month = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (calendar.startOfDay(for: date), endDate)
    }
    
    private func nextMonth(with date: Date, calendar: Calendar, timeZone: TimeZone, locale: Locale) -> Dates {
        var dateComponents = calendar.dateComponents([.year, .month], from: date)
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.month! += 1
        let startDate = calendar.date(from: dateComponents)!
        dateComponents = .init()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.month = 1
        dateComponents.second = -1
        let endDate = calendar.date(byAdding: dateComponents, to: startDate)!
        return (startDate, endDate)
    }

    var id: String { return title }
}

final class SearchDateButton: UIButton {
    let dateType: SearchDateType
    init(dateType: SearchDateType) {
        self.dateType = dateType
        super.init(frame: .zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var setUp: () -> Void = {
        setTitle(dateType.title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        contentEdgeInsets = .init(top: 4, left: 8, bottom: 4, right: 8)
        setTitleColor(Colors.link, for: .normal)
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.cornerRadius = 12
        layer.borderColor = Colors.link.cgColor
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        return {}
    }()
}

struct SearchDateButtonView: UIViewRepresentable {
    let dateType: SearchDateType
    
    func makeUIView(context: UIViewRepresentableContext<SearchDateButtonView>) -> SearchDateButton {
        return SearchDateButton(dateType: dateType)
    }
    
    func updateUIView(_ uiView: SearchDateButton, context: UIViewRepresentableContext<SearchDateButtonView>) {
        // nothing todo
    }
}

struct SearchDateButtonView_Preview: PreviewProvider {
    static var previews: some View {
        ForEach(SearchDateType.allCases) { searchDateType in
            SearchDateButtonView(dateType: searchDateType)
                .previewLayout(.sizeThatFits)
        }
    }
}

protocol SearchDateDelegate: AnyObject {
    func searchDate(_ searchDate: SearchDate, didSelect dateType: SearchDateType)
}

final class SearchDate: UIView {
    private var cancellables: [AnyCancellable] = []
    weak var delegate: SearchDateDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    private lazy var setUp: () -> Void = {
        addScrollView()
        addStackView()
        addDateTypes()
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        return {}
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.accessibilityIdentifier = "scrollView"
        return scrollView
    }()

    private func addScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 48),
            bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fill
        stackView.accessibilityIdentifier = "stackView"
        return stackView
    }()
    
    private func addStackView() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 16),
            stackView.heightAnchor.constraint(equalToConstant: 48),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
        ])
    }
    
    private var buttons: [SearchDateButton] = []

    private func addDateTypes() {
        SearchDateType.allCases.forEach { searchDateType in
            let button = SearchDateButton(dateType: searchDateType)
            button.addTarget(self, action: #selector(tap(button:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            buttons.append(button)
        }
    }

    @objc private func tap(button: SearchDateButton) {
        delegate?.searchDate(self, didSelect: button.dateType)
        handleSelected(with: button.dateType)
    }
    
    private func handleSelected(with searchDateType: SearchDateType) {
        buttons.forEach { button in
            if button.dateType == searchDateType {
                button.backgroundColor = Colors.link
                button.setTitleColor(.systemBackground, for: .normal)
            } else {
                button.backgroundColor = .systemBackground
                button.setTitleColor(Colors.link, for: .normal)
            }
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let superSize = super.intrinsicContentSize
        return CGSize(width: superSize.width, height: 48)
    }
}

struct SearchDateView: UIViewRepresentable {
    @Binding var selectedSearchDateType: SearchDateType?
    
    func makeUIView(context: UIViewRepresentableContext<SearchDateView>) -> SearchDate {
        let searchDate = SearchDate()
        searchDate.delegate = context.coordinator
        return searchDate
    }
    
    final class Coordinator: SearchDateDelegate {
        @Binding var selectedSearchDateType: SearchDateType?
        init(selectedSearchDateType: Binding<SearchDateType?>) {
            _selectedSearchDateType = selectedSearchDateType
        }
        
        func searchDate(_ searchDate: SearchDate, didSelect dateType: SearchDateType) {
            selectedSearchDateType = dateType
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedSearchDateType: $selectedSearchDateType)
    }
    
    func updateUIView(_ uiView: SearchDate, context: UIViewRepresentableContext<SearchDateView>) {
        // nothing todo
    }
}

struct SearchDateView_Preview: PreviewProvider {
    @State static var selectedSearchDateType: SearchDateType?
    
    static var previews: some View {
        SearchDateView(selectedSearchDateType: $selectedSearchDateType)
            .previewLayout(.sizeThatFits)
    }
}
