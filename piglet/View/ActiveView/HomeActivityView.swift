//
//  HomeActivityView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomeActivityView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var activityTab = ActivityTab.LifeSavingsBank
    
    init() {
        if colorScheme == .light {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black // 当前页指示器为黑色
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3) // 其他页指示器半透明黑色
        }
    }
    var body: some View {
        VStack {
            // Tab切换列表
            HomeActivityTabView(activityTab: $activityTab)
            Spacer().frame(height:10)
            Spacer().frame(height:30)
            Button(action: {
                
            }, label: {
                Text("Participate")
                    .modifier(ButtonModifier())
            })
            Spacer()
        }
        .navigationTitle("Activity")
        .background {
            HomeActivityViewBackground(activityTab: $activityTab)
        }
    }
}

private struct HomeActivityTabView: View {
    @Binding var activityTab: ActivityTab
    var body: some View {
        TabView(selection: $activityTab) {
            ForEach(ActivityTab.allCases) { item in
                Image(item.image)
                    .HomeActivityTabImageView()
                    .overlay {
                        HStack {
                            VStack {
                                Spacer()
                                VStack(alignment: .leading,spacing: 10) {
                                    Text(LocalizedStringKey(item.title))
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Text(LocalizedStringKey(item.description))
                                        .font(.footnote)
                                }
                                .foregroundColor(.white)
                                .padding(20)
                                .background {
                                    Rectangle()
                                        .scale(0.5)
                                        .blur(radius: 30)
                                }
                            }
                            Spacer()
                        }
                    }
                    .offset(y: -10)
                    .tag(item)
            }
        }
        .tabViewStyle(.page) // 隐藏分页指示器
        .frame(height: 480)
    }
}

private struct HomeActivityViewBackground: View {
    @Binding var activityTab:ActivityTab
    var body: some View {
        switch activityTab {
        case .LifeSavingsBank:
            Image("life0")
                .HomeActivityBgView()
        case .LivingAllowance:
            Image("life1")
                .HomeActivityBgView()
        }
    }
}

extension Image {
    func HomeActivityTabImageView() -> some View{
        self
            .resizable()
            .scaledToFill()
            .frame(width:300, height: 400)
            .cornerRadius(30)
            .shadow(radius: 2)
    }
}

extension Image {
    func HomeActivityBgView() -> some View{
        self
            .resizable()
            .scaledToFill()
            .blur(radius: 20)
            .opacity(0.3)
            .ignoresSafeArea()
    }
}

#Preview {
    NavigationStack {
        HomeActivityView()
    }
}
