//
//  CalendarView.swift
//  FreeTimePickerCatalys
//
//  Created by Kazuya Ueoka on 2020/03/01.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

extension Date {
    func firstDay(calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        var dateComponents = calendar.dateComponents([.year, .month], from: self)
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.day = 1
        return calendar.date(from: dateComponents)!
    }

    func lastDay(calendar: Calendar = .init(identifier: .gregorian), timeZone: TimeZone = .current) -> Date {
        var calendar = calendar
        calendar.timeZone = timeZone
        var dateComponents = calendar.dateComponents([.year, .month], from: self)
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.month = dateComponents.month.flatMap { $0 + 1 }
        dateComponents.day = 0
        return calendar.date(from: dateComponents)!
    }

    func numberOfWeeks(calendar: Calendar = .init(identifier: .gregorian), timeZone _: TimeZone = .current) -> Int {
        calendar.range(of: .weekOfMonth, in: .month, for: self)!.count
    }
}

final class CalendarViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var cancellables: [AnyCancellable] = []

    @Binding var date: Date?
    init(date: Binding<Date?>) {
        _date = date
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var closeButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handle(closeButton:)))
        button.accessibilityIdentifier = "closeButton"
        return button
    }()

    @objc private func handle(closeButton _: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    lazy var todayButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("today", comment: "today"), style: .plain, target: self, action: #selector(handle(todayButton:)))
        button.accessibilityIdentifier = "todayButton"
        return button
    }()

    @objc private func handle(todayButton _: UIBarButtonItem) {
        currentDate = Date()
        updateAppendWeekDay()
        updateYearMonth()
    }

    lazy var titleView: TitleView = {
        let titleView = TitleView()
        titleView.yearMonth = yearMonth
        titleView.accessibilityIdentifier = "titleView"
        return titleView
    }()

    override func loadView() {
        super.loadView()
        currentDate = date ?? Date()
        navigationItem.leftBarButtonItem = closeButton
        navigationItem.rightBarButtonItem = todayButton
        navigationItem.titleView = titleView
        configureCollectionView()

        titleView.$backMonth.sink { [weak self] void in
            guard void != nil else { return }
            self?.backMonth()
        }.store(in: &cancellables)

        titleView.$nextMonth.sink { [weak self] void in
            guard void != nil else { return }
            self?.nextMonth()
        }.store(in: &cancellables)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateYearMonth()
        updateAppendWeekDay()
    }

    private func backMonth() {
        currentDate = yearMonth.back(calendar)
        updateAppendWeekDay()
        updateYearMonth()
    }

    private func nextMonth() {
        currentDate = yearMonth.next(calendar)
        updateAppendWeekDay()
        updateYearMonth()
    }

    private func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(WeekdayCell.self, forCellWithReuseIdentifier: WeekdayCell.reuseIdentifier)
        collectionView.register(DayCell.self, forCellWithReuseIdentifier: DayCell.reuseIdentifier)
    }

    override func numberOfSections(in _: UICollectionView) -> Int {
        2
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return Weekday.allCases.count
        } else {
            return Weekday.allCases.count * currentDate.numberOfWeeks(calendar: calendar, timeZone: timeZone)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = WeekdayCell.reuse(collectionView, at: indexPath)
            cell.weekdayLabel.text = Weekday.allCases[indexPath.item].localized()
            return cell
        } else {
            let cell = DayCell.reuse(collectionView, at: indexPath)
            cell.update(with: date(at: indexPath.item), and: yearMonth, calendar: calendar)
            return cell
        }
    }

    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 1 else { return }
        let date = self.date(at: indexPath.item)
        self.date = date
        dismiss(animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let itemLength: CGFloat = floor(collectionView.bounds.size.width / 7)
        return CGSize(width: itemLength, height: 44)
    }

    enum Weekday: String, CaseIterable {
        case sunday
        case monday
        case tuesday
        case wednesday
        case thursday
        case friday
        case saturday

        func localized() -> String {
            NSLocalizedString(rawValue, comment: rawValue)
        }
    }

    struct YearMonth {
        let year: Int
        let month: Int

        func back(_ calendar: Calendar = .init(identifier: .gregorian)) -> Date {
            var dateComponents = DateComponents()
            dateComponents.calendar = calendar
            dateComponents.year = year
            dateComponents.month = month - 1
            dateComponents.day = 1
            return calendar.date(from: dateComponents)!
        }

        func next(_ calendar: Calendar = .init(identifier: .gregorian)) -> Date {
            var dateComponents = DateComponents()
            dateComponents.calendar = calendar
            dateComponents.year = year
            dateComponents.month = month + 1
            dateComponents.day = 1
            return calendar.date(from: dateComponents)!
        }

        func date(_ calendar: Calendar = .init(identifier: .gregorian)) -> Date {
            var dateComponents = DateComponents()
            dateComponents.calendar = calendar
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = 1
            return calendar.date(from: dateComponents)!
        }

        func toString(calendar: Calendar, locale: Locale = .current) -> String? {
            guard let dateFormat = DateFormatter.dateFormat(fromTemplate: "MMM, yyyy", options: 0, locale: locale) else {
                return nil
            }
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = calendar
            dateFormatter.timeZone = .current
            dateFormatter.locale = locale
            dateFormatter.dateFormat = dateFormat
            return dateFormatter.string(from: date(calendar))
        }
    }

    var yearMonth: YearMonth!

    private func updateYearMonth() {
        let dateComponents = calendar.dateComponents([.year, .month], from: currentDate)
        yearMonth = .init(year: dateComponents.year!, month: dateComponents.month!)
        titleView.yearMonth = yearMonth
    }

    private var timeZone: TimeZone = .current
    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar
    }()

    private var appendWeekDay: Int!

    private func updateAppendWeekDay() {
        let firstDay = currentDate.firstDay(calendar: calendar, timeZone: timeZone)
        let weekday = calendar.component(.weekday, from: firstDay)
        appendWeekDay = weekday - 1
    }

    var currentDate: Date! {
        didSet {
            updateYearMonth()
            collectionView.reloadData()
        }
    }

    func date(at item: Int) -> Date {
        var dateComponents = DateComponents()
        dateComponents.calendar = calendar
        dateComponents.timeZone = timeZone
        dateComponents.year = yearMonth.year
        dateComponents.month = yearMonth.month
        dateComponents.day = (item + 1) - appendWeekDay
        return calendar.date(from: dateComponents)!
    }

    final class TitleView: UIView {
        @Published var yearMonth: YearMonth!
        @Published var backMonth: Void?
        @Published var nextMonth: Void?
        private var cancellables: [AnyCancellable] = []

        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setUp()
        }

        private lazy var setUp: () -> Void = {
            addTitleLabel()
            addBackButton()
            addNextButton()

            $yearMonth
                .map { $0?.toString(calendar: .init(identifier: .gregorian)) }
                .sink { [weak self] yearMonth in
                    self?.titleLabel.text = yearMonth
                    self?.sizeToFit()
                }
                .store(in: &cancellables)

            return {}
        }()

        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .label
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 14)
            return label
        }()

        private func addTitleLabel() {
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
                bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }

        lazy var backButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
            button.addTarget(self, action: #selector(handle(backButton:)), for: .touchUpInside)
            button.accessibilityIdentifier = "backButton"
            return button
        }()

        @objc private func handle(backButton _: UIButton) {
            backMonth = ()
        }

        private func addBackButton() {
            backButton.translatesAutoresizingMaskIntoConstraints = false
            addSubview(backButton)
            NSLayoutConstraint.activate([
                backButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
                titleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 16)
            ])
        }

        lazy var nextButton: UIButton = {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            button.addTarget(self, action: #selector(handle(nextButton:)), for: .touchUpInside)
            button.accessibilityIdentifier = "nextButton"
            return button
        }()

        @objc private func handle(nextButton _: UIButton) {
            nextMonth = ()
        }

        private func addNextButton() {
            nextButton.translatesAutoresizingMaskIntoConstraints = false
            addSubview(nextButton)
            NSLayoutConstraint.activate([
                nextButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                trailingAnchor.constraint(equalTo: nextButton.trailingAnchor, constant: 8),
                nextButton.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 16)
            ])
        }
    }

    final class WeekdayCell: UICollectionViewCell, Reusable {
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setUp()
        }

        private lazy var setUp: () -> Void = {
            backgroundColor = .secondarySystemBackground
            weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(weekdayLabel)
            NSLayoutConstraint.activate([
                weekdayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                weekdayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            return {}
        }()

        lazy var weekdayLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 12)
            label.textColor = .label
            label.accessibilityIdentifier = "weekdayLabel"
            return label
        }()
    }

    final class DayCell: UICollectionViewCell, Reusable {
        override init(frame: CGRect) {
            super.init(frame: frame)
            setUp()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setUp()
        }

        private lazy var setUp: () -> Void = {
            dayLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(dayLabel)
            NSLayoutConstraint.activate([
                dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            return {}
        }()

        lazy var dayLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .boldSystemFont(ofSize: 14)
            label.textColor = .label
            label.accessibilityIdentifier = "dayLabel"
            return label
        }()

        func update(with date: Date, and yearMonth: YearMonth, calendar: Calendar = .init(identifier: .gregorian)) {
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
            dayLabel.text = String(dateComponents.day!)
            if dateComponents.year == yearMonth.year, dateComponents.month == yearMonth.month {
                dayLabel.textColor = .label
            } else {
                dayLabel.textColor = .systemGray
            }
        }
    }
}

struct CalendarView: UIViewControllerRepresentable {
    @Binding var date: Date?
    typealias UIViewControllerType = UINavigationController

    func makeUIViewController(context _: UIViewControllerRepresentableContext<CalendarView>) -> UINavigationController {
        let calendarViewController = CalendarViewController(date: $date)
        return UINavigationController(rootViewController: calendarViewController)
    }

    func updateUIViewController(_: UINavigationController, context _: UIViewControllerRepresentableContext<CalendarView>) {
        // nothing todo
    }
}
