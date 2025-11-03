//
//  HomeActivityView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomeActivityView: View {
    var activityTab = ActivityTab.livingAllowance
    var body: some View {
        ScrollView(showsIndicators: false) {
            
        }
        .navigationTitle("Activity")
        .background {
            switch activityTab {
            case .survivalMoneyBank:
                Image("life0")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 30)
                    .opacity(0.2)
                    .ignoresSafeArea()
            case .livingAllowance:
                Image("life1")
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 30)
                    .opacity(0.2)
                    .ignoresSafeArea()
            }
        }
    }
}
