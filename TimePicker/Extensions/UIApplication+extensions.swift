//
//  UIApplication+extensions.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/09.
//  Copyright © 2020 fromKK. All rights reserved.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
