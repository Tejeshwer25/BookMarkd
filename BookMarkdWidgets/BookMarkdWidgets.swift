//
//  BookMarkdWidgets.swift
//  BookMarkdWidgets
//
//  Created by Tejeshwer Singh on 27/04/26.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "Hi there!")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), quote: "Hi there! 2")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, quote: "Hi there!! \(hourOffset + 1)")
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let quote: String
}

struct BookMarkdWidgetsEntryView : View {
    var entry: Provider.Entry
    @Query var quotes: [QuotesModel]

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "quote.opening")
                    .resizable()
                    .frame(width: 27, height: 20)
                    .opacity(0.25)
                Spacer()
            }
            
            Text(quotes.randomElement()?.text ?? "No quote available")
                .fontDesign(.serif)
            Spacer()
            
            HStack {
                Spacer()
                Image(systemName: "quote.closing")
                    .resizable()
                    .frame(width: 27, height: 20)
                    .opacity(0.25)                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
    }
}

struct BookMarkdWidgets: Widget {
    let kind: String = "BookMarkdWidgets"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, provider: Provider()) { entry in
            BookMarkdWidgetsEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
                .modelContainer(for: [QuotesModel.self])
        }
    }
}

#Preview(as: .systemSmall) {
    BookMarkdWidgets()
} timeline: {
    SimpleEntry(date: .now, quote: "Test quote")
}
