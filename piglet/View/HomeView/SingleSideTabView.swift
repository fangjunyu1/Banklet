//
//  SingleSideTabView.swift
//  piglet
//
//  Created by 方君宇 on 2026/6/2.
//

import SwiftUI

struct SingleSideTabView: View {
    @Environment(\.colorScheme) var colorScheme
    var tab: HomeTab
    @Binding var selectedTab: HomeTab
    @State private var clicked = false
    var body: some View {
        Button(action: {
            clicked.toggle()
            withAnimation{ selectedTab = tab } // 设置当前的索引
        },label: {
            HStack(spacing: 16) {
                Image(systemName: tab.icon)
                    .font(.system(size: 26))
                    .symbolEffect(.bounce, value: clicked)
                    .foregroundColor(selectedTab == tab ? AppColor.appColor : colorScheme == .light ? .gray : .white)
                    .frame(width: 30)
                Text(LocalizedStringKey(tab.title))
                    .font(.title3)
                    .foregroundColor(selectedTab == tab ? AppColor.appColor : colorScheme == .light ? .gray : .white)
                    .lineLimit(1)
                Spacer()
            }
            .foregroundColor(AppColor.gray)
            .contentShape(Rectangle())
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background {
                AppColor.appColor
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .opacity(selectedTab == tab ? 0.1 : 0)
            }
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
