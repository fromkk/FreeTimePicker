//
//  SearchView.swift
//  TimePicker
//
//  Created by Kazuya Ueoka on 2020/02/06.
//  Copyright © 2020 fromKK. All rights reserved.
//

import Combine
import Core
import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            SearchFormView(viewModel: viewModel)
                .accessibility(identifier: "searchFormView")
            VStack(alignment: .leading) {
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
                    .accessibility(identifier: "searchButton")
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .padding(16)
        .sheet(isPresented: $viewModel.hasResults) {
            DetailView(viewModel: .init(dates: self.viewModel.result))
                .accessibility(identifier: "detailView")
        }
        .alert(isPresented: $viewModel.noResults) {
            Alert(title: Text("No free time"), message: nil, dismissButton: Alert.Button.default(Text("OK")))
        }
    }

    private func search() {
        viewModel.search()
    }
}

struct SearchView_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SearchView(viewModel: SearchViewModel(eventRepository: EventRepository()))
        }
    }
}
