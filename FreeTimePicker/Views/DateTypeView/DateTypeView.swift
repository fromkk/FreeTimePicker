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
