//
//  SearchFormView.swift
//  FreeTimePicker
//
//  Created by Kazuya Ueoka on 2020/02/22.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import SwiftUI

struct CustomDates: View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        HStack(alignment: .center) {
            if viewModel.searchDateType == .custom {
                DatePickerView(datePickerModel: .date, date: $viewModel.customStartDate, text: $viewModel.customStartText)
                DatePickerView(datePickerModel: .date, date: $viewModel.customEndDate, text: $viewModel.customEndText)
            } else {
                EmptyView()
            }
        }.padding([.bottom], 8)
    }
}

struct ToggleViews: View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Transit time").bold()
            DatePickerView(datePickerModel: .time, date: $viewModel.transitTimeDate, text: $viewModel.transitTimeText)
            Toggle(isOn: $viewModel.ignoreAllDays, label: {
                Text("Ignore all days").bold()
            }).padding([.trailing], 8)
            Toggle(isOn: $viewModel.ignoreHolidays, label: {
                Text("Ignore holidays").bold()
            }).padding([.top, .trailing], 8)
        }
    }
}

struct SearchFormView: View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Date").bold()
            SearchDateView(selectedSearchDateType: $viewModel.searchDateType)
            CustomDates(viewModel: viewModel)
            Text("Min free time").bold()
            DatePickerView(datePickerModel: .time, date: $viewModel.minFreeTimeDate, text: $viewModel.minFreeTimeText)
            Text("Search range").bold()
            HStack {
                DatePickerView(datePickerModel: .time, date: $viewModel.fromTime, text: $viewModel.fromText)
                Text(" - ")
                DatePickerView(datePickerModel: .time, date: $viewModel.toTime, text: $viewModel.toText)
            }
            ToggleViews(viewModel: viewModel)
        }
    }
}
