//
//  HomeActivityView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomeActivityView: View {
    @Environment(AppStorageManager.self) var appStorage
    @Environment(SoundManager.self) var soundManager
    @Environment(\.colorScheme) var colorScheme
    @State private var homeActivityVM = HomeActivityViewModel()
    @State private var activitySheet = false
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // Tab切换列表
            HomeActivityTabView()
                .onChange(of: homeActivityVM.tab) { oldValue, newValue in
                    // 振动
                    HapticManager.shared.selectionChanged()
                    if appStorage.isActivityMusic {
                        playMusicForCurrentTab(for: homeActivityVM.tab)
                    }
                }
            Spacer().frame(height:20)
            Button(action: {
                activitySheet.toggle()
                // 振动
                HapticManager.shared.selectionChanged()
            }, label: {
                Text("Participate")
                    .modifier(ButtonModifier())
            })
            .sheet(isPresented: $activitySheet) {
                HomeActivitySheetView()
                    .environment(homeActivityVM)
            }
            Spacer()
        }
        .navigationTitle("Activity")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ActivityMusicView()
            }
        }
        .onAppear {
            if appStorage.isActivityMusic {
                playMusicForCurrentTab(for: homeActivityVM.tab)    // 播放音乐
            }
            if colorScheme == .light {
                UIPageControl.appearance().currentPageIndicatorTintColor = .black // 当前页指示器为黑色
                UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3) // 其他页指示器半透明黑色
            }
        }
        .background {
            HomeActivityViewBackground(activityTab: $homeActivityVM.tab)
        }
        .onDisappear {
            soundManager.stopAllSound()
        }
        .environment(homeActivityVM)
    }
    
    private func playMusicForCurrentTab(for tab: ActivityTab) {
        switch tab {
        case .LifeSavingsBank:
            soundManager.playBackgroundMusic(named: "life0")
        case .EmergencyFund:
            soundManager.playBackgroundMusic(named: "life1")
        }
    }
}

private struct HomeActivityTabView: View {
    @EnvironmentObject var homeActivity: HomeActivityViewModel
    let imgHeight: CGFloat = 380
    let imgWidth: CGFloat = 280
    var TabHeight: CGFloat { imgHeight + 60 }
    var body: some View {
        TabView(selection: $homeActivity.tab) {
            ForEach(ActivityTab.allCases) { item in
                Image(item.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: imgWidth, height: imgHeight)
                    .cornerRadius(30)
                    .shadow(radius: 1)
                    .overlay { HomeActivityTabTextView(item: item)}
                    .offset(y: -15)
                    .tag(item)
            }
        }
        .tabViewStyle(.page) // 隐藏分页指示器
        .frame(height: TabHeight)
    }
}

private struct HomeActivityTabTextView: View {
    var item: ActivityTab
    var body: some View {
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
                        .foregroundColor(Color.black)
                        .blur(radius: 30)
                }
            }
            Spacer()
        }
    }
}

private struct HomeActivityViewBackground: View {
    @Binding var activityTab:ActivityTab
    var body: some View {
        switch activityTab {
        case .LifeSavingsBank:
            Image("life0")
                .HomeActivityBgView()
        case .EmergencyFund:
            Image("life1")
                .HomeActivityBgView()
        }
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
            .environment(AppStorageManager.shared)
            .environment(SoundManager.shared)
    }
}
