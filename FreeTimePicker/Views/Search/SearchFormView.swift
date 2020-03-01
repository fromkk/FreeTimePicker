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
    @State var beginStartDate: Bool = false
    @State var endStartDate: Bool = false
    @State var beginEndDate: Bool = false
    @State var endEndDate: Bool = false

    var body: some View {
        HStack(alignment: .center) {
            if viewModel.searchDateType == .custom {
                #if targetEnvironment(macCatalyst)
                    DatePickerView(datePickerModel: .date, date: $viewModel.customStartDate, text: $viewModel.customStartText, begin: $beginStartDate, end: $endStartDate)
                        .accessibility(identifier: "customStartDatePicker")
                        .sheet(isPresented: $beginStartDate) {
                            CalendarView(date: self.$viewModel.customStartDate)
                        }
                    DatePickerView(datePickerModel: .date, date: $viewModel.customEndDate, text: $viewModel.customEndText, begin: $beginEndDate, end: $endEndDate)
                        .accessibility(identifier: "customEndDatePicker")
                        .sheet(isPresented: $beginEndDate) {
                            CalendarView(date: self.$viewModel.customEndDate)
                        }
                #else
                    DatePickerView(datePickerModel: .date, date: $viewModel.customStartDate, text: $viewModel.customStartText, begin: $beginStartDate, end: $endStartDate)
                        .accessibility(identifier: "customStartDatePicker")
                    DatePickerView(datePickerModel: .date, date: $viewModel.customEndDate, text: $viewModel.customEndText, begin: $beginEndDate, end: $endEndDate)
                        .accessibility(identifier: "customEndDatePicker")
                #endif
            } else {
                EmptyView()
            }
        }
        .padding([.bottom], 8)
    }
}

#if DEBUG
    struct CustomDates_Preview: PreviewProvider {
        static var previews: some View {
            Group {
                CustomDates(viewModel: {
                    let viewModel = SearchViewModel(eventRepository: EventRepositorySpy())
                    viewModel.searchDateType = .custom
                    return viewModel
                }())
                    .previewLayout(.sizeThatFits)
                CustomDates(viewModel: {
                    let viewModel = SearchViewModel(eventRepository: EventRepositorySpy())
                    viewModel.searchDateType = .today
                    return viewModel
                }())
                    .previewLayout(.sizeThatFits)
            }
        }
    }
#endif

struct ToggleViews: View {
    @ObservedObject var viewModel: SearchViewModel
    @State var beginTransitDate: Bool = false
    @State var endTransitDate: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Transit time").bold()
            DatePickerView(datePickerModel: .time, date: $viewModel.transitTimeDate, text: $viewModel.transitTimeText, begin: $beginTransitDate, end: $endTransitDate)
                .accessibility(identifier: "transitDatePickerView")
            Toggle(isOn: $viewModel.ignoreAllDays, label: {
                Text("Ignore all days").bold()
            })
                .padding([.trailing], 8)
                .accessibility(identifier: "ignoreAllDaySwitch")
            Toggle(isOn: $viewModel.ignoreHolidays, label: {
                Text("Ignore holidays").bold()
            })
                .padding([.top, .trailing], 8)
                .accessibility(identifier: "ignoreHolidaysSwitch")
        }
    }
}

#if DEBUG
    struct ToggleViews_Preview: PreviewProvider {
        static var previews: some View {
            Group {
                ToggleViews(viewModel: {
                    let viewModel = SearchViewModel(eventRepository: EventRepositorySpy())
                    viewModel.searchDateType = .today
                    return viewModel
                }())
            }.previewLayout(.sizeThatFits)
        }
    }
#endif

struct SearchFormView: View {
    @ObservedObject var viewModel: SearchViewModel
    @State var beginFreeTime: Bool = false
    @State var endFreeTime: Bool = false
    @State var beginFromTime: Bool = false
    @State var endFromTime: Bool = false
    @State var beginToTime: Bool = false
    @State var endToTime: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Date").bold()
            SearchDateView(selectedSearchDateType: $viewModel.searchDateType)
                .accessibility(identifier: "searchDateTypeView")
            CustomDates(viewModel: viewModel)
                .accessibility(identifier: "customDatesView")
            Text("Min free time").bold()
            DatePickerView(datePickerModel: .time, date: $viewModel.minFreeTimeDate, text: $viewModel.minFreeTimeText, begin: $beginFreeTime, end: $endFreeTime)
                .accessibility(identifier: "minFreeTimeDatePicker")
            Text("Search range").bold()
            HStack {
                DatePickerView(datePickerModel: .time, date: $viewModel.fromTime, text: $viewModel.fromText, begin: $beginFromTime, end: $endFromTime)
                    .accessibility(identifier: "fromTimePickerView")
                Text(" - ")
                DatePickerView(datePickerModel: .time, date: $viewModel.toTime, text: $viewModel.toText, begin: $beginToTime, end: $endToTime)
                    .accessibility(identifier: "toTimePickerView")
            }
            ToggleViews(viewModel: viewModel)
                .accessibility(identifier: "toggleViews")
        }
    }
}

#if DEBUG
    struct SearchFormView_Preview: PreviewProvider {
        static var previews: some View {
            Group {
                SearchFormView(viewModel: {
                    let viewModel = SearchViewModel(eventRepository: EventRepositorySpy())
                    viewModel.searchDateType = .today
                    return viewModel
                }())
            }.previewLayout(.sizeThatFits)
        }
    }
#endif
