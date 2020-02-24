//
//  DateTypeButton.swift
//  Today
//
//  Created by Kazuya Ueoka on 2020/02/24.
//  Copyright © 2020 fromKK. All rights reserved.
//

import UIKit
import UI

@IBDesignable
final class DateTypeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private lazy var setUp: () -> Void = {
        backgroundColor = .clear
        layer.borderColor = Colors.link.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = 3
        layer.masksToBounds = true
        contentEdgeInsets = .init(top: 4, left: 16, bottom: 4, right: 16)
        setTitleColor(Colors.link, for: .normal)
        return {}
    }()

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUp()
    }
}
