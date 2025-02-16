//
//  BankletWidgetBundle.swift
//  BankletWidget
//
//  Created by 方君宇 on 2025/2/13.
//

import WidgetKit
import SwiftUI

@main
struct BankletWidgetBundle: WidgetBundle {
    var body: some Widget {
        BankletWidget()
        BankletWidgetBackground()
//        BankletWidgetLiveActivity()
    }
}
