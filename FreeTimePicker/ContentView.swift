//
//  ContentView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Core
import EventKit
import SwiftUI

struct ContentView: View {
    @ObservedObject var calendarPermissionViewModel: CalendarPermissionViewModel
    let bannerUnitID: String?

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                if self.calendarPermissionViewModel.isGranted {
                    SearchView(viewModel: SearchViewModel(eventRepository: EventRepository()))
                        .navigationBarTitle("Search free time")
                } else {
                    NoPermissionView()
                }
                AdBannerView(adUnitID: bannerUnitID)
                    .frame(height: 50, alignment: .center)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.calendarPermissionViewModel.request()
        }
    }
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                ContentView(
                    calendarPermissionViewModel: .init(repository: CalendarPermissionRepositoryStub(stubbedIsGranted: false)),
                    bannerUnitID: "ca-app-pub-3940256099942544/2934735716"
                )
                ContentView(
                    calendarPermissionViewModel: .init(repository: CalendarPermissionRepositoryStub(stubbedIsGranted: true)),
                    bannerUnitID: "ca-app-pub-3940256099942544/2934735716"
                )
            }
        }
    }
#endif
