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

    extension NSTouchBarItem.Identifier {
        static let group: NSTouchBarItem.Identifier = .init("group")
        static let search: NSTouchBarItem.Identifier = .init("search")
    }

    final class SearchDateTypeTouchBar: UIResponder, ObservableObject, NSTouchBarDelegate {
        weak var searchViewModel: SearchViewModel?
        override func makeTouchBar() -> NSTouchBar? {
            let touchBar = NSTouchBar()
            touchBar.customizationIdentifier = .searchDateType
            touchBar.defaultItemIdentifiers = [.group, .search]
            touchBar.customizationAllowedItemIdentifiers = [.group, .search]
            touchBar.delegate = self
            return touchBar
        }

        func touchBar(_: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
            switch identifier {
            case .group:
                return NSGroupTouchBarItem(identifier: .group, items: SearchDateType.allCases.map {
                    NSButtonTouchBarItem(identifier: .init($0.title), title: $0.title, target: self, action: #selector(handle(_:)))
                })
            case .search:
                return NSButtonTouchBarItem(identifier: identifier, image: UIImage(systemName: "magnifyingglass.circle.fill")!, target: self, action: #selector(handle(_:)))
            default:
                return nil
            }
        }

        @objc private func handle(_ button: NSButtonTouchBarItem) {
            if let searchDateType = SearchDateType.allCases.first(where: { $0.title == button.identifier.rawValue }) {
                searchViewModel?.searchDateType = searchDateType
            } else {
                switch button.identifier {
                case .search:
                    searchViewModel?.search()
                default:
                    break
                }
            }
        }
    }
#endif
