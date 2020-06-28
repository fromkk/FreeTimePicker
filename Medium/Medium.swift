//
//  Medium.swift
//  Medium
//
//  Created by Kazuya Ueoka on 2020/06/28.
//  Copyright © 2020 fromKK. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import Core

struct Provider: IntentTimelineProvider {
    public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries: [SimpleEntry] = [
            .init(date: Date(), configuration: configuration)
        ]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let configuration: ConfigurationIntent
}

struct PlaceholderView: View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct MediumEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                ForEach(SearchDateType.allCases[0..<3]) { searchDateType in
                    Link(searchDateType.title, destination: destinationURL(of: searchDateType))

                }
            }
            HStack {
                ForEach(SearchDateType.allCases[3..<6]) { searchDateType in
                    Link(searchDateType.title, destination: destinationURL(of: searchDateType))
                }
            }
        }
    }

    private func destinationURL(of searchDateType: SearchDateType) -> URL {
        let index = SearchDateType.allCases.firstIndex(of: searchDateType)!
        return URL(string: "pity://search_date_type/\(index + 1)")!
    }
}

@main
struct Medium: Widget {
    private let kind: String = "Medium"

    public var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
            MediumEntryView(entry: entry)

        }
        .configurationDisplayName("Pity")
        .description("This is a shortcut buttons widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct Medium_Previews: PreviewProvider {
    static var previews: some View {
        MediumEntryView(entry: .init(date: Date(), configuration: .init()))
    }
}
