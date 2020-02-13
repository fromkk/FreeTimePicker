//
//  DetailView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import SwiftUI
import Combine

final class DetailViewController: UIViewController {
    @Published var text: String = ""
    private var cancellables: [AnyCancellable] = []
    lazy var shareBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "square.and.arrow.up"),
        style: .done,
        target: self,
        action: #selector(share)
    )
    lazy var closeBarButtonItem: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(close))

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
        let activityViewController = UIActivityViewController(activityItems: [self.text], applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = shareBarButtonItem
        present(activityViewController, animated: true, completion: nil)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}

struct DetailView: UIViewControllerRepresentable {
    var viewModel: DetailViewModel
    func makeUIViewController(context: UIViewControllerRepresentableContext<DetailView>) -> UINavigationController {
        let detailVC =  DetailViewController()
        detailVC.text = viewModel.text
        let navigationController = UINavigationController(rootViewController: detailVC)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: UIViewControllerRepresentableContext<DetailView>) {
        // nothin todo
    }
}
