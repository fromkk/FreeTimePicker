//
//  CalendarPermissionViewModel.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import EventKit
import Foundation

public protocol CalendarPermissionRepositoryProtocol {
    func request(_ callback: @escaping (Bool) -> Void)
}

public final class CalendarPermissionRepository: CalendarPermissionRepositoryProtocol {
    public init() {}

    public func request(_ callback: @escaping (Bool) -> Void) {
        let status = EKEventStore.authorizationStatus(for: .event)
        handleAuthorizationStatus(status, callback: callback)
    }

    private func handleAuthorizationStatus(_ status: EKAuthorizationStatus, callback: @escaping (Bool) -> Void) {
        switch status {
        case .authorized:
            callback(true)
        case .notDetermined:
            EKEventStore().requestAccess(to: .event) { _, _ in
                let status = EKEventStore.authorizationStatus(for: .event)
                DispatchQueue.main.async {
                    self.handleAuthorizationStatus(status, callback: callback)
                }
            }
        default:
            callback(false)
        }
    }
}

#if DEBUG
    public final class CalendarPermissionRepositoryStub: CalendarPermissionRepositoryProtocol {
        public var stubbedIsGranted: Bool
        public init(stubbedIsGranted: Bool) {
            self.stubbedIsGranted = stubbedIsGranted
        }

        public func request(_ callback: @escaping (Bool) -> Void) {
            callback(stubbedIsGranted)
        }
    }
#endif

public final class CalendarPermissionViewModel: ObservableObject {
    private let repository: CalendarPermissionRepositoryProtocol
    public init(repository: CalendarPermissionRepositoryProtocol) {
        self.repository = repository
    }

    @Published public var isGranted: Bool = false

    public func request() {
        repository.request { [weak self] isGranted in
            self?.isGranted = isGranted
        }
    }
}
