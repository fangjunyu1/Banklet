//
//  BankletWidgetLiveActivity.swift
//  BankletWidget
//
//  Created by 方君宇 on 2025/2/13.
//

//import ActivityKit
//import WidgetKit
//import SwiftUI

//struct BankletWidgetAttributes: ActivityAttributes {
//    public struct ContentState: Codable, Hashable {
//        // Dynamic stateful properties about your activity go here!
//        var emoji: String
//    }
//
//    // Fixed non-changing properties about your activity go here!
//    var name: String
//}
//
//struct BankletWidgetLiveActivity: Widget {
//    var body: some WidgetConfiguration {
//        ActivityConfiguration(for: BankletWidgetAttributes.self) { context in
//            // Lock screen/banner UI goes here
//            VStack {
//                Text("Hello \(context.state.emoji)")
//            }
//            .activityBackgroundTint(Color.cyan)
//            .activitySystemActionForegroundColor(Color.black)
//
//        } dynamicIsland: { context in
//            DynamicIsland {
//                // Expanded UI goes here.  Compose the expanded UI through
//                // various regions, like leading/trailing/center/bottom
//                DynamicIslandExpandedRegion(.leading) {
//                    Text("Leading")
//                }
//                DynamicIslandExpandedRegion(.trailing) {
//                    Text("Trailing")
//                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom \(context.state.emoji)")
//                    // more content
//                }
//            } compactLeading: {
//                Text("L")
//            } compactTrailing: {
//                Text("T \(context.state.emoji)")
//            } minimal: {
//                Text(context.state.emoji)
//            }
//            .widgetURL(URL(string: "http://www.apple.com"))
//            .keylineTint(Color.red)
//        }
//    }
//}
//
//extension BankletWidgetAttributes {
//    fileprivate static var preview: BankletWidgetAttributes {
//        BankletWidgetAttributes(name: "World")
//    }
//}
//
//extension BankletWidgetAttributes.ContentState {
//    fileprivate static var smiley: BankletWidgetAttributes.ContentState {
//        BankletWidgetAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: BankletWidgetAttributes.ContentState {
//         BankletWidgetAttributes.ContentState(emoji: "🤩")
//     }
//}
//
//#Preview("Notification", as: .content, using: BankletWidgetAttributes.preview) {
//   BankletWidgetLiveActivity()
//} contentStates: {
//    BankletWidgetAttributes.ContentState.smiley
//    BankletWidgetAttributes.ContentState.starEyes
//}
