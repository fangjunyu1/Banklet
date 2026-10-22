//
//  FontModifier.swift
//  piglet
//
//  Created by 方君宇 on 2026/10/22.
//
// ======================
// MARK: 文字样式
// ======================


import SwiftUI

// 大型标题
struct LargeTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
    }
}

// 普通标题
struct TitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
    }
}

// 灰色注释文字
struct FootNoteModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundStyle(.gray)
            .multilineTextAlignment(.center)
    }
}
