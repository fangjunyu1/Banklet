//
//  SpacedContainer.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/22.
//

import SwiftUI
struct SpacedContainer<Content: View>: View {
    let isCompactScreen: Bool
    let content: Content

    init(isCompactScreen: Bool ,@ViewBuilder content: () -> Content) {
        self.isCompactScreen = isCompactScreen
        self.content = content()
    }

    var body: some View {
        Group {
            if isCompactScreen {
                HStack(spacing: 0) {
                    content
                }
            } else {
                VStack(spacing: 0) {
                    content
                }
            }
        }
    }
}


