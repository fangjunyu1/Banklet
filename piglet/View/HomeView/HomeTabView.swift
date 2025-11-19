//
//  HomeTabView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

struct HomeTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: HomeTab
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                ForEach(HomeTab.allCases, id: \.self) { index in
                    SingleTabView(tab: index, selectedTab: $selectedTab)
                }
            }
            .padding(.vertical,12)
            .padding(.horizontal,12)
            .background(
                HStack {
                    Rectangle()
                        .fill(colorScheme == .light ? .white : AppColor.appGrayColor)
                        .frame(width: 88,height: 58)
                        .cornerRadius(40)
                        .offset(x:5)
                        .offset(x: CGFloat(68) * CGFloat(selectedTab.rawValue))
                        .opacity(0.8)
                    Spacer()
                }
            )
            .background(
                Rectangle()
                    .fill(.regularMaterial)
                    .blur(radius: 3)
                    .cornerRadius(100)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                    .opacity(0.9)
            )
        }
        .padding(.bottom,20)
        .ignoresSafeArea()
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
