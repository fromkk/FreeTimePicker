//
//  DetailView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import SwiftUI

final class DetailViewController: UIViewController {
    @Published var text: String = ""
    private var cancellables: [AnyCancellable] = []
    lazy var shareBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "square.and.arrow.up"),
            style: .done,
            target: self,
            action: #selector(share)
        )
        item.accessibilityIdentifier = "shareButton"
        return item
    }()

    lazy var closeBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))
        item.accessibilityIdentifier = "closeButton"
        return item
    }()

    override func loadView() {
        super.loadView()
        title = NSLocalizedString("Free time", comment: "Free time")
        navigationItem.leftBarButtonItem = closeBarButtonItem
        navigationItem.rightBarButtonItem = shareBarButtonItem
        addTextView()
        bind()
    }

    private func bind() {
        $text.assign(to: \.text, on: textView).store(in: &cancellables)
    }

    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isEditable = false
        textView.accessibilityIdentifier = "textView"
        return textView
    }()

    private func addTextView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: textView.trailingAnchor),
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: textView.bottomAnchor)
        ])
    }

    @objc private func share() {
        let activityViewController = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = shareBarButtonItem
        present(activityViewController, animated: true, completion: nil)
    }

    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}

struct DetailView: UIViewControllerRepresentable {
    var viewModel: DetailViewModel
    func makeUIViewController(context _: UIViewControllerRepresentableContext<DetailView>) -> UINavigationController {
        let detailVC = DetailViewController()
        detailVC.text = viewModel.text
        let navigationController = UINavigationController(rootViewController: detailVC)
        return navigationController
    }

    func updateUIViewController(_: UINavigationController, context _: UIViewControllerRepresentableContext<DetailView>) {
        // nothin todo
    }
}
