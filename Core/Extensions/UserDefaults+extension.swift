//
//  UserDefaults+extension.swift
//  Core
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

public extension UserDefaults {
    static let grouped = UserDefaults(suiteName: Constants.groupIdentifier)
}
