//
//  UserDefaultsWrapper.swift
//  Core
//
//  Created by Kazuya Ueoka on 2020/02/14.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Foundation

public protocol UserDefaultsKeyRepresentable: RawRepresentable where RawValue == String {}

@propertyWrapper
public struct UserDefaultsOptionalWrapper<T, Key: UserDefaultsKeyRepresentable> {
    private let key: Key
    private let userDefaults: UserDefaults
    public init(key: Key, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }

    public var wrappedValue: T? {
        get {
            userDefaults.object(forKey: key.rawValue) as? T
        }
        set {
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }
}

@propertyWrapper
public struct UserDefaultsWrapper<T, Key: UserDefaultsKeyRepresentable> {
    private let key: Key
    private let userDefaults: UserDefaults
    private let defaultValue: T
    public init(key: Key, userDefaults: UserDefaults = .standard, defaultValue: T) {
        self.key = key
        self.userDefaults = userDefaults
        self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get {
            (userDefaults.object(forKey: key.rawValue) as? T) ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key.rawValue)
        }
    }
}
