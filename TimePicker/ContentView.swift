//
//  ContentView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import SwiftUI
import EventKit

struct ContentView: View {
    @ObservedObject var calendarPermissionViewModel: CalendarPermissionViewModel
    
    var body: some View {
        NavigationView {
            if self.calendarPermissionViewModel.isGranted {
                SearchView(viewModel: SearchViewModel(eventRepository: EventRepository()))
                .navigationBarTitle("Search free time")
            } else {
                NoPermissionView()
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
            ContentView(calendarPermissionViewModel: .init(repository: CalendarPermissionRepositoryStub(stubbedIsGranted: false)))
            ContentView(calendarPermissionViewModel: .init(repository: CalendarPermissionRepositoryStub(stubbedIsGranted: true)))
        }
    }
}
#endif
