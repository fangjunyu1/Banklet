//
//  HomeTabView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

struct HomeTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    // Tab元组
    let tabs = [
        ("house.fill", "Home"),
        ("flag.fill", "Activity"),
        ("chart.pie.fill", "Stats"),
        ("gearshape.fill", "Settings")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 50) {
                ForEach(tabs.indices, id: \.self) { index in
                    let (image, tab) = tabs[index]
                    SingleTabView(HomeImage: image, HomeText: tab,index: index, selectedTab: $selectedTab)
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
                        .offset(x: CGFloat(75) * CGFloat(selectedTab))
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
    }
}
