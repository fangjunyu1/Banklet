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
        Button(action: {
            print("点击了Tab")
            clicked.toggle()
            withAnimation{ selectedTab = tab } // 设置当前的索引
        },label: {
            VStack(spacing: 5) {
                Image(systemName: tab.icon)
                    .imageScale(.large)
                    .symbolEffect(.bounce, value: clicked)
                    .foregroundColor(selectedTab == tab ? AppColor.appColor : colorScheme == .light ? .gray : .white)
                Text(LocalizedStringKey(tab.title))
                    .font(.footnote)
                    .foregroundColor(selectedTab == tab ? AppColor.appColor : colorScheme == .light ? .gray : .white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
            }
            .frame(width:70)
            .foregroundColor(AppColor.gray)
            .contentShape(Rectangle())
        })
        .buttonStyle(.plain)
    }
}

private struct HomeTabPreviewView: View {
    @State private var tab = HomeTab.activity
    var body: some View {
        HomeTabView(selectedTab: $tab)
            .environment(\.locale, .init(identifier: "ta"))
    }
}
#Preview {
    HomeTabPreviewView()
}
