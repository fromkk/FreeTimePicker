//
//  MenuProvider.swift
//  FreeTimePickerCatalys
//
//  Created by Kazuya Ueoka on 2020/03/02.
//  Copyright © 2020 fromKK. All rights reserved.
//

import UIKit
#if canImport(AppKit)
    import AppKit
#endif

struct MenuProvider {
    static func run(with builder: UIMenuBuilder) {
        guard builder.system == UIMenuSystem.main else { return }
        builder.remove(menu: .help)
    }
}
