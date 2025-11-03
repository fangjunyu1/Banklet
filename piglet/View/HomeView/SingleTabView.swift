//
//  SingleTabView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

struct SingleTabView: View {
    @Environment(\.colorScheme) var colorScheme
    var tab: HomeTab
    @Binding var selectedTab: HomeTab
    @State private var clicked = false
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: tab.icon)
                .imageScale(.large)
                .symbolEffect(.bounce, value: clicked)
                .foregroundColor(selectedTab == tab ? AppColor.appColor : colorScheme == .light ? .gray : .white)
            Text(LocalizedStringKey(tab.title))
                .textScale(.secondary)
                .foregroundColor(selectedTab == tab ? AppColor.appColor : colorScheme == .light ? .gray : .white)
        }
        .foregroundColor(AppColor.gray)
        .onTapGesture {
            clicked.toggle()
            withAnimation{ selectedTab = tab } // 设置当前的索引
        }
        .contentShape(Rectangle())
    }
}
