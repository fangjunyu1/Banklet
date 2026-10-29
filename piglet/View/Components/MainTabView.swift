//
//  MainTabView.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: HomeTab
    let onCreatePiggyBank: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                // 左侧 Tab 菜单
                leftTabView
                
                Spacer()
                
                // 右侧创建按钮
                rightTabView
            }
        }
        .padding(.horizontal, 40)
        .padding(.bottom,30)
        .ignoresSafeArea()
    }
    
    // 左侧 Tab 菜单
    var leftTabView: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(HomeTab.allCases, id: \.self) { index in
                    SingleTabView(tab: index, selectedTab: $selectedTab)
                }
            }
            .padding(12)
            .background(
                HStack {
                    Rectangle()
                        .fill(colorScheme == .light ? .white : AppColor.appGrayColor)
                        .frame(width: 60,height: 40)
                        .cornerRadius(40)
                        .offset(x:12)
                        .offset(x: CGFloat(60) * CGFloat(selectedTab.rawValue))
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
    }
    
    // 右侧创建存钱罐按钮
    var rightTabView: some View {
        Button(action: {
            onCreatePiggyBank()
        }, label: {
            Image(systemName: "plus")
                .foregroundStyle(colorScheme == .light ? .white : AppColor.appGrayColor)
                .frame(width: 40,height: 40)
                .background(colorScheme == .light ? AppColor.appGrayColor : .white)
                .cornerRadius(40)
                .shadow(radius: 3)
        })
    }
}

struct SingleTabView: View {
    @Environment(\.colorScheme) var colorScheme
    var tab: HomeTab
    @Binding var selectedTab: HomeTab
    @State private var clicked = false
    var body: some View {
        Button(action: {
            clicked.toggle()
            withAnimation{ selectedTab = tab } // 设置当前的索引
        },label: {
            VStack(spacing: 5) {
                Image(systemName: tab.icon)
                    .imageScale(.large)
                    .symbolEffect(.bounce, value: clicked)
                    .foregroundColor(selectedTab == tab ? AppColor.appColor : colorScheme == .light ? .gray : .white)
            }
            .frame(width:60)
            .foregroundColor(AppColor.gray)
            .contentShape(Rectangle())
        })
        .buttonStyle(.plain)
    }
}

private struct HomeTabPreviewView: View {
    @State private var tab = HomeTab.activity
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image("bg0")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .frame(
                        width: proxy.size.width,
                        height: proxy.size.height
                    )
                MainTabView(selectedTab: $tab) {
                    
                }
            }
        }
    }
}
#Preview {
    HomeTabPreviewView()
}
