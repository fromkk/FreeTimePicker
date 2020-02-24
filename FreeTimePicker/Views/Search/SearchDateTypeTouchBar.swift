//
//  SearchDateTypeTouchBar.swift
//  FreeTimePickerCatalys
//
//  Created by Kazuya Ueoka on 2020/02/24.
//  Copyright © 2020 fromKK. All rights reserved.
//

import UIKit
#if canImport(AppKit)
    import AppKit
#endif
import Combine
import Core

#if targetEnvironment(macCatalyst)
    extension NSTouchBar.CustomizationIdentifier {
        static let searchDateType: NSTouchBar.CustomizationIdentifier = .init("searchDateType")
    }

    final class SearchDateTypeTouchBar: UIResponder, ObservableObject, NSTouchBarDelegate {
        weak var searchViewModel: SearchViewModel?
        override func makeTouchBar() -> NSTouchBar? {
            let touchBar = NSTouchBar()
            touchBar.customizationIdentifier = .searchDateType
            touchBar.defaultItemIdentifiers = SearchDateType.allCases.map { NSTouchBarItem.Identifier($0.title) }
            touchBar.customizationAllowedItemIdentifiers = SearchDateType.allCases.map { NSTouchBarItem.Identifier($0.title) }
            touchBar.delegate = self
            return touchBar
        }

        func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
            if let searchDateType = SearchDateType.allCases.first(where: { $0.title == identifier.rawValue }) {
                return NSButtonTouchBarItem(identifier: identifier, title: searchDateType.title, target: self, action: #selector(handle(_:)))
            } else {
                return nil
            }
        }

        @objc private func handle(_ button: NSButtonTouchBarItem) {
            if let searchDateType = SearchDateType.allCases.first(where: { $0.title == button.identifier.rawValue }) {
                searchViewModel?.searchDateType = searchDateType
            }
        }
    }
#endif
