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
            HStack(spacing: 50) {
                ForEach(HomeTab.allCases, id: \.self) { index in
                    SingleTabView(tab: index, selectedTab: $selectedTab)
                }
            }
            .padding(.vertical,12)
            .padding(.horizontal,30)
            .background(
                HStack {
                    Rectangle()
                        .fill(colorScheme == .light ? .white : AppColor.appGrayColor)
                        .frame(width: 80,height: 60)
                        .cornerRadius(40)
                        .offset(x:5)
                        .offset(x: CGFloat(75) * CGFloat(selectedTab.rawValue))
                    Spacer()
                }
            )
            .background(
                Rectangle()
                    .fill(.regularMaterial)
                    .blur(radius: 3)
                    .cornerRadius(100)
                    .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
            )
        }
        .padding(.bottom,20)
        .ignoresSafeArea()
    }
}
