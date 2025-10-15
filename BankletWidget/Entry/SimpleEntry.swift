//
//  SimpleEntry.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/13.
//

import WidgetKit
import SwiftUI

// Banklet显示的小组件条目
struct SimpleEntry: TimelineEntry {
    var date: Date

    init(date: Date = Date()) {
        self.date = date
    }
}
