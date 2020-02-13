//
//  SearchView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import SwiftUI
import Combine

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel
    private var cancellables: [AnyCancellable] = []

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading) {
                Group {
                    Text("Date").bold()
                    SearchDateView(selectedSearchDateType: $viewModel.searchDateType)
                    Text("Min free time").bold()
                    DatePickerView(datePickerModel: .time, date: $viewModel.minFreeTimeDate, text: $viewModel.minFreeTimeText)
                    Text("Search range").bold()
                    HStack {
                        DatePickerView(datePickerModel: .time, date: $viewModel.fromTime, text: $viewModel.fromText)
                        Text(" - ")
                        DatePickerView(datePickerModel: .time, date: $viewModel.toTime, text: $viewModel.toText)
                    }
                    Text("Transit time").bold()
                    DatePickerView(datePickerModel: .time, date: $viewModel.transitTimeDate, text: $viewModel.transitTimeText)
                    Toggle(isOn: $viewModel.ignoreAllDays, label: {
                        Text("Ignore all days").bold()
                    }).padding([.trailing], 8)
                    Toggle(isOn: $viewModel.ignoreHolidays, label: {
                        Text("Ignore holidays").bold()
                    }).padding([.top, .trailing], 8)
                }
                Spacer(minLength: 32)
                Button(action: {
                    self.search()
                }, label: {
                    Text("Search")
                        .bold()
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .foregroundColor(Color.white)
                })
                    .frame(height: 48)
                    .background(self.viewModel.isValid ? Color.blue : Color.gray)
                    .cornerRadius(24)
                    .disabled(!self.viewModel.isValid)
            }
        }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(16)
        .sheet(isPresented: $viewModel.hasResults) {
            DetailView(viewModel: .init(dates: self.viewModel.result))
        }        
    }

    private func search() {
        viewModel.search()
        if let searchDateType = viewModel.searchDateType {
            SiriRegister.register(with: searchDateType)
        }
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView(viewModel: SearchViewModel(eventRepository: EventRepository()))
        }
    }
}
