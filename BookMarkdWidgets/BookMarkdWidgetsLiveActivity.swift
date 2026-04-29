//
//  BookMarkdWidgetsLiveActivity.swift
//  BookMarkdWidgets
//
//  Created by Tejeshwer Singh on 27/04/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct BookMarkdWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct BookMarkdWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: BookMarkdWidgetsAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension BookMarkdWidgetsAttributes {
    fileprivate static var preview: BookMarkdWidgetsAttributes {
        BookMarkdWidgetsAttributes(name: "World")
    }
}

extension BookMarkdWidgetsAttributes.ContentState {
    fileprivate static var smiley: BookMarkdWidgetsAttributes.ContentState {
        BookMarkdWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: BookMarkdWidgetsAttributes.ContentState {
         BookMarkdWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: BookMarkdWidgetsAttributes.preview) {
   BookMarkdWidgetsLiveActivity()
} contentStates: {
    BookMarkdWidgetsAttributes.ContentState.smiley
    BookMarkdWidgetsAttributes.ContentState.starEyes
}
