//
//  GifView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/13.
//

import WidgetKit
import SwiftUI
import ClockHandRotationKit

struct GifView : View {
    var entry: GifWidgetEntry

    var body: some View {
        VStack {
            GifImageView(gifName: "\(entry.loopAnimation)")
                .onAppear {
                    print("entry.loopAnimation:\(entry.loopAnimation)")
                }
        }
    }
}

struct GifAnimateWidget: Widget {
    let kind: String = "GifWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: GifWidgetProvider()) { entry in
            GifView(entry: entry)
                .containerBackground(.clear, for: .widget)
        }
        .configurationDisplayName("Animation Widget")
        .description("Play animation on the desktop in a loop.")
        .supportedFamilies([.systemSmall])
    }
}

#Preview(as: .systemSmall) {
    GifAnimateWidget()
} timeline: {
    GifWidgetEntry(date: Date(), loopAnimation: "Home0")
}
