//
//  HomeSideTabView.swift
//  piglet
//
//  Created by 方君宇 on 2026/06/02.
//

import SwiftUI

struct HomeSideTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: HomeTab
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                ForEach(HomeTab.allCases.filter { $0 != .settings }, id: \.self) { index in
                    SingleSideTabView(tab: index, selectedTab: $selectedTab)
                }
            }
            Spacer()
            SingleSideTabView(tab: .settings, selectedTab: $selectedTab)
        }
        .padding(20)
    }
}

private struct HomeTabPreviewView: View {
    @State private var tab = HomeTab.activity
    var body: some View {
        ZStack {
            Image("bg0")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            HomeTabView(selectedTab: $tab)
        }
    }
}
#Preview {
    HomeTabPreviewView()
}
