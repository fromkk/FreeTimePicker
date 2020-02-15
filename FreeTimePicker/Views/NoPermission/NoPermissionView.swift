//
//  NoPermissionView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import SwiftUI

struct NoPermissionView: View {
    var body: some View {
        VStack {
            Text("No permissions")
            Button(action: {
                self.openSettings()
            }, label: {
                Text("Go to Settings")
            })
        }
    }

    func openSettings() {
        let url = URL(string: UIApplication.openSettingsURLString)!
        guard UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct NoPermissionView_Preview: PreviewProvider {
    static var previews: some View {
        NoPermissionView()
    }
}
