//
//  SiriRegister.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/12.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation
import Intents

final class SiriRegister {
    static func register(with dateType: SearchDateType) {
        let intents = FreeTimeIntent()
        intents.dateType = dateType.toDateType()
        let interaction = INInteraction(intent: intents, response: nil)
        interaction.donate { error in
            assert(error == nil)
            if let error = error {
                debugPrint(#function, error)
            }
        }
    }
}
