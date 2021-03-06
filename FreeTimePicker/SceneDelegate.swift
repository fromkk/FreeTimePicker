//
//  SceneDelegate.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Core
import SwiftUI
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let searchDateTypeHandler = SearchDateTypeHandler()
    #if targetEnvironment(macCatalyst)
        private let searchViewModelTouchBar = SearchDateTypeTouchBar()
    #endif

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options: UIScene.ConnectionOptions) {
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let bannerUnitID = Bundle.main.infoDictionary?["GADBannerUnitIdentifier"] as? String

            #if targetEnvironment(macCatalyst)
                let contentView = ContentView(
                    calendarPermissionViewModel: .init(repository: CalendarPermissionRepository()),
                    bannerUnitID: bannerUnitID
                )
                .environmentObject(searchDateTypeHandler)
                .environmentObject(searchViewModelTouchBar)
                windowScene.touchBar = searchViewModelTouchBar.makeTouchBar()
            #else
                let contentView = ContentView(
                    calendarPermissionViewModel: .init(repository: CalendarPermissionRepository()),
                    bannerUnitID: bannerUnitID
                )
                .environmentObject(searchDateTypeHandler)
            #endif

            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }

        if let userActivity = options.userActivities.first {
            handle(userActivity)
        } else if let urlContext = options.urlContexts.first {
            handle(urlContext.url)
        }
    }

    func sceneDidDisconnect(_: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let urlContext = URLContexts.first else { return }
        let url = urlContext.url
        handle(url)
    }

    private func handle(_ url: URL) {
        guard let urlType = URLHandler.handle(url) else { return }
        switch urlType {
        case let .searchDateType(searchDateType):
            searchDateTypeHandler.searchDateType = searchDateType
        }
    }

    func scene(_: UIScene, continue userActivity: NSUserActivity) {
        handle(userActivity)
    }

    private func handle(_ userActivity: NSUserActivity) {
        if let freeTimePickerIntent = userActivity.interaction?.intent as? FreeTimePickerIntent {
            searchDateTypeHandler.searchDateType = freeTimePickerIntent.dateType.toSearchDateType()
        }
    }
}
