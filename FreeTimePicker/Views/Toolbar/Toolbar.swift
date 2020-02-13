//
//  Toolbar.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/09.
//  Copyright © 2020 fromKK. All rights reserved.
//

import UIKit
import Combine

final class Toolbar: UIToolbar {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }

    private lazy var setUp: () -> Void = {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems([flexibleSpace, completionButton], animated: false)
        return {}
    }()

    let completion: PassthroughSubject<Void, Never> = .init()
    private lazy var completionButton: UIBarButtonItem = .init(barButtonSystemItem: .done, target: self, action: #selector(tap(completionButton:)))
    @objc private func tap(completionButton: UIBarButtonItem) {
        completion.send(())
    }
}
