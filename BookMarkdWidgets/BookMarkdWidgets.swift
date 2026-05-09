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
    @Environment(\.widgetFamily) var family
    var entry: Provider.Entry
    @Query var books: [BookModel]
    
    @ViewBuilder
    var body: some View {
        let book = books.filter({ $0.quotes.count > 0 }).randomElement()!
        let quote = book.quotes.randomElement()?.text
        
        switch family {
        case .systemSmall, .systemMedium:
            VStack(alignment: .center) {
                HStack {
                    Image(systemName: "quote.opening")
                        .resizable()
                        .frame(width: 27, height: 20)
                        .opacity(0.25)
                        .foregroundStyle(.accent)
                    Spacer()
                }
                
                Spacer()
                Text(quote ?? "No quote available")
                    .fontDesign(.serif)
                    .multilineTextAlignment(.center)
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: "quote.closing")
                        .resizable()
                        .frame(width: 27, height: 20)
                        .opacity(0.25)
                        .foregroundStyle(.accent)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
        case .systemLarge:
            VStack(alignment: .center) {
                HStack {
                    Image(systemName: "quote.opening")
                        .resizable()
                        .frame(width: 27, height: 20)
                        .opacity(0.25)
                        .foregroundStyle(.accent)
                    Spacer()
                }
                
                Spacer()
                Text(quote ?? "No quote available. Add a quote to see it here.")
                    .fontDesign(.serif)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                if quote != nil {
                    Divider()
                        .foregroundStyle(.accent)
                    
                    Text("\(book.title) by \(book.authorName.joined(separator: ", "))")
                        .font(.caption)
                        .fontDesign(.serif)
                        .foregroundStyle(.accent)
                }
                Spacer()
                
                HStack {
                    Spacer()
                    Image(systemName: "quote.closing")
                        .resizable()
                        .frame(width: 27, height: 20)
                        .opacity(0.25)
                        .foregroundStyle(.accent)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .init(horizontal: .leading, vertical: .top))
        case .systemExtraLarge:
            VStack {
                Text("Hello, World! systemExtraLarge")
            }
        case .accessoryCircular:
            VStack {
                Text("Hello, World! accessoryCircular")
            }
        case .accessoryRectangular:
            VStack {
                Text("Hello, World! accessoryRectangular")
            }
        case .accessoryInline:
            VStack {
                Text("Hello, World! accessoryInline")
            }
        @unknown default:
            VStack {
                Text("Hello, World! unkn")
            }
        }
        
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
