//
//  AddToSiriButton.swift
//  FreeTimePicker
//
//  Created by Kazuya Ueoka on 2020/02/19.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Core
import Intents
import IntentsUI
import SwiftUI
import UIKit

final class AddToSiriViewController: UIViewController, INUIAddVoiceShortcutViewControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton()
    }

    lazy var addToSiriButton: INUIAddVoiceShortcutButton = {
        let button = INUIAddVoiceShortcutButton(style: .automaticOutline)
        button.addTarget(self, action: #selector(tap(button:)), for: .touchUpInside)
        return button
    }()

    private func addButton() {
        addToSiriButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addToSiriButton)
        NSLayoutConstraint.activate([
            addToSiriButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addToSiriButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func tap(button _: INUIAddVoiceShortcutButton) {
        guard let shortcut = INShortcut(intent: FreeTimePickerIntent()) else {
            return
        }
        let vc = INUIAddVoiceShortcutViewController(shortcut: shortcut)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }

    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith _: INVoiceShortcut?, error _: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

struct AddToSiriButton: UIViewControllerRepresentable {
    func makeUIViewController(context _: UIViewControllerRepresentableContext<AddToSiriButton>) -> AddToSiriViewController {
        AddToSiriViewController()
    }

    func updateUIViewController(_: AddToSiriViewController, context _: UIViewControllerRepresentableContext<AddToSiriButton>) {
        // nothing todo
    }
}
