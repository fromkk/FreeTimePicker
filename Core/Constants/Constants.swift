//
//  Constants.swift
//  Core
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

public enum Constants {
    public static let groupIdentifier = "group.me.fromkk.FreeTimePicker"
    public struct SearchParameterKeys: UserDefaultsKeyRepresentable {
        public let rawValue: String
        public init(rawValue: String) {
            self.rawValue = "me.fromkk.FreeTimePicker." + rawValue
        }

        public static let searchDateType = SearchParameterKeys(rawValue: "searchDateType")
        public static let minFreeTimeDate = SearchParameterKeys(rawValue: "minFreeTimeDate")
        public static let fromTime = SearchParameterKeys(rawValue: "fromTime")
        public static let toTime = SearchParameterKeys(rawValue: "toTime")
        public static let transitTimeDate = SearchParameterKeys(rawValue: "transitTimeDate")
        public static let ignoreAllDays = SearchParameterKeys(rawValue: "ignoreAllDays")
        public static let ignoreHolidays = SearchParameterKeys(rawValue: "ignoreHolidays")
    }
}
