//
//  URLHandler.swift
//  FreeTimePicker
//
//  Created by Kazuya Ueoka on 2020/02/24.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Core
import Foundation

enum URLType {
    case searchDateType(SearchDateType)
}

enum URLHandler {
    private static let allowSchemes: [String] = ["pity", "freetimepicker"]
    static func handle(_ url: URL) -> URLType? {
        guard let scheme = url.scheme, allowSchemes.contains(scheme) else {
            return nil
        }

        guard let host = url.host else {
            return nil
        }

        switch host {
        case "search_date_type":
            let path = url.path
            let indexString = path.replacingCharacters(in: path.startIndex ..< path.index(path.startIndex, offsetBy: 1), with: "")
            guard let number = Int(indexString) else {
                return nil
            }
            let index = number - 1
            guard SearchDateType.allCases.count > index else {
                return nil
            }
            return .searchDateType(SearchDateType.allCases[index])
        default:
            return nil
        }
    }
}
