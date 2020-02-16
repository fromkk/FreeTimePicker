//
//  DatePickerView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/09.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import SwiftUI
import UIKit

extension UIDatePicker.Mode {
    func dateFormat(locale: Locale = .current) -> String? {
        switch self {
        case .time, .countDownTimer:
            return DateFormatter.dateFormat(fromTemplate: "H:mm", options: 0, locale: locale)
        case .date:
            return DateFormatter.dateFormat(fromTemplate: "MMM d, yyyy", options: 0, locale: locale)
        case .dateAndTime:
            return DateFormatter.dateFormat(fromTemplate: "MMM d, yyyy, jm", options: 0, locale: locale)
        @unknown default:
            return nil
        }
    }

    func placeholder(locale _: Locale = .current) -> String? {
        dateFormat()
    }
}

protocol DatePickerDelegate: AnyObject {
    func datePickerDidChanged(_ datePicker: DatePicker)
}

final class DatePicker: UITextField {
    weak var datePickerDelegate: DatePickerDelegate?
    private var cancellables: [AnyCancellable] = []

    convenience init(datePickerMode: UIDatePicker.Mode) {
        self.init()
        setUp(datePickerMode: datePickerMode)
        setUpNotification()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private lazy var toolbar: Toolbar = {
        let toolbar = Toolbar(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 44)))
        toolbar.completion.sink { [weak self] _ in
            guard let self = self else { return }
            self.datePickerDidChange(self.datePicker)
            self.datePickerDelegate?.datePickerDidChanged(self)
            self.resignFirstResponder()
        }.store(in: &cancellables)
        return toolbar
    }()

    var datePickerModel: UIDatePicker.Mode {
        get {
            datePicker.datePickerMode
        }
        set {
            setUp(datePickerMode: newValue)
        }
    }

    private func setUp(datePickerMode: UIDatePicker.Mode = .date) {
        datePicker.datePickerMode = datePickerMode
        inputView = datePicker
        inputAccessoryView = toolbar
        placeholder = datePickerMode.placeholder()
        datePicker.date = datePicker.calendar.startOfDay(for: Date())
    }

    private func setUpNotification() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .sink { [weak self] _ in
                self?.setText(self?.text)
            }.store(in: &cancellables)
    }

    override var text: String? {
        didSet {
            setText(text)
        }
    }

    private func setText(_ text: String?) {
        guard let text = text, let date = convertToDate(text) else { return }
        datePicker.date = date
        datePickerDelegate?.datePickerDidChanged(self)
    }

    var date: Date? {
        get {
            datePicker.date
        }
        set {
            guard let date = newValue else { return }
            datePicker.date = date
            datePickerDidChange(datePicker)
        }
    }

    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 216)))
        picker.calendar = Calendar(identifier: .gregorian)
        picker.timeZone = .current
        picker.locale = Locale(identifier: "ja_JP")
        picker.addTarget(self, action: #selector(datePickerDidChange(_:)), for: .valueChanged)
        return picker
    }()

    lazy var dateFormatter: DateFormatter = DateFormatter()

    @objc private func datePickerDidChange(_ picker: UIDatePicker) {
        super.text = convertToString(picker.date)
        datePickerDelegate?.datePickerDidChanged(self)
    }

    private func setUpDateFormatter(
        calendar: Calendar = .init(identifier: .gregorian),
        locale: Locale = .current,
        timeZone: TimeZone = .current
    ) {
        var calendar = calendar
        calendar.locale = locale
        calendar.timeZone = timeZone
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
    }

    private func convertToString(_ date: Date, locale: Locale = .current) -> String? {
        guard let dateFormat = datePicker.datePickerMode.dateFormat(locale: locale) else { return nil }
        setUpDateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }

    private func convertToDate(_ string: String, locale: Locale = .current) -> Date? {
        guard let dateFormat = datePicker.datePickerMode.dateFormat(locale: locale) else { return nil }
        setUpDateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: string)
    }
}

struct DatePickerView: UIViewRepresentable {
    func makeCoordinator() -> DatePickerView.Coordinator {
        Coordinator(date: $date, text: $text)
    }

    let datePickerModel: UIDatePicker.Mode
    @Binding var date: Date?
    @Binding var text: String?

    final class Coordinator: DatePickerDelegate {
        @Binding var date: Date?
        @Binding var text: String?
        init(date: Binding<Date?>, text: Binding<String?>) {
            _date = date
            _text = text
        }

        func datePickerDidChanged(_ datePicker: DatePicker) {
            date = datePicker.date
            text = datePicker.text
        }
    }

    func makeUIView(context: UIViewRepresentableContext<DatePickerView>) -> DatePicker {
        let datePicker = DatePicker(datePickerMode: datePickerModel)
        datePicker.datePickerDelegate = context.coordinator
        return datePicker
    }

    func updateUIView(_ uiView: DatePicker, context _: UIViewRepresentableContext<DatePickerView>) {
        if let text = text, uiView.text != text {
            uiView.text = text
        }

        if let date = date, uiView.date != date {
            uiView.date = date
        }
    }
}

struct DatePickerView_Preview: PreviewProvider {
    @State static var date: Date?
    @State static var text: String?

    static var previews: some View {
        DatePickerView(datePickerModel: .date, date: $date, text: $text)
    }
}
