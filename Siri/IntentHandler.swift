//
//  IntentHandler.swift
//  Siri
//
//  Created by Kazuya Ueoka on 2020/02/13.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Intents
import Core

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        if intent is FreeTimePickerIntent {
            return FreeTimePickerIntentHandler()
        } else {
            return self
        }
    }
}
