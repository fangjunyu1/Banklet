//
//  SettingButton.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/9.
//

import SwiftUI

struct SettingButton<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme // 读取当前配色方案
    let action:() -> Void
    let content: Content
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    var body: some View {
        // 赞助应用按钮
        Button(action:action) {
            HStack {
                content
            }
            .padding(14)
            .foregroundColor(colorScheme == .light ? .black : .white)
            .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
            .cornerRadius(10)
        }
    }
}

// 设置页中的HStack
struct SettingView<Content:View>: View {
    @Environment(\.colorScheme) var colorScheme // 读取当前配色方案
    let content: Content
    
    init(@ViewBuilder content:() -> Content) {
        self.content = content()
    }
    
    var body: some View {
        HStack {
            content
        }
        .padding(14)
        .foregroundColor(colorScheme == .light ? .black : .white)
        .background(colorScheme == .light ? .white : Color(hex:"1f1f1f"))
        .cornerRadius(10)
    }
}


// 内购按钮样式
struct InAppPurchaseCompletionButton<Content: View>: View {
    
    @Environment(\.colorScheme) var colorScheme // 读取当前配色方案
    let action:() -> Void
    let content: Content
    
    init(action: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.action = action
        self.content = content()
    }
    var body: some View {
        // 赞助应用按钮
        Button(action:action) {
            HStack {
                content
            }
            .padding(14)
            .foregroundColor(colorScheme == .light ? .white : .white)
            .background(colorScheme == .light ? Color(hex:"1677FF") : Color(hex:"1677FF"))
            .cornerRadius(10)
        }
    }
}
