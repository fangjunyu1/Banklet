//
//  SingleTabView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

struct SingleTabView: View {
    @Environment(\.colorScheme) var colorScheme
    var HomeImage: String
    var HomeText:String
    var index: Int
    @Binding var selectedTab: Int
    @State private var clicked = false
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: HomeImage)
                .imageScale(.large)
                .symbolEffect(.bounce, value: clicked)
                .foregroundColor(selectedTab == index ? AppColor.appColor : colorScheme == .light ? .gray : .white)
            Text(LocalizedStringKey(HomeText))
                .textScale(.secondary)
                .foregroundColor(selectedTab == index ? AppColor.appColor : colorScheme == .light ? .gray : .white)
        }
        .foregroundColor(AppColor.gray)
        .onTapGesture {
            clicked.toggle()
            withAnimation{ selectedTab = index } // 设置当前的索引
        }
        .contentShape(Rectangle())
    }
}
