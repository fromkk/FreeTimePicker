//
//  TodayViewController.swift
//  Today
//
//  Created by Kazuya Ueoka on 2020/02/24.
//  Copyright © 2020 fromKK. All rights reserved.
//

import UIKit
import NotificationCenter
import Core

class TodayViewController: UIViewController, NCWidgetProviding {

    @IBOutlet private weak var todayButton: UIButton!
    @IBOutlet private weak var tomorrowButton: UIButton!
    @IBOutlet private weak var thisWeekButton: UIButton!
    @IBOutlet private weak var nextWeekButton: UIButton!
    @IBOutlet private weak var thisMonthButton: UIButton!
    @IBOutlet private weak var nextMonthButton: UIButton!

    private lazy var buttons: [UIButton] = [
        todayButton, tomorrowButton, thisWeekButton, nextWeekButton, thisMonthButton, nextMonthButton
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        zip(buttons, SearchDateType.allCases).forEach { button, dateType in
            button.setTitle(dateType.title, for: .normal)
            button.addTarget(self, action: #selector(handle(button:)), for: .touchUpInside)
        }
    }

    @objc private func handle(button: UIButton) {
        guard let index = buttons.firstIndex(of: button) else { return }
        let openURL = URL(string: "pity://search_date_type/\(index + 1)")!
        extensionContext?.open(openURL, completionHandler: nil)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.newData)
    }

}
