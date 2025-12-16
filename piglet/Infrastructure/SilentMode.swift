//
//  SilentMode.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/26.
//

import SwiftUI

struct SlientMode: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appStorage: AppStorageManager
    @EnvironmentObject var idleManager: IdleTimerManager
    @Binding var isSlientMode: Bool
    var body: some View {
        var buttonColor: Color {
            if colorScheme == .light {
                AppColor.appGrayColor.opacity(0.8)
            } else {
                Color.white.opacity(0.8)
            }
        }
        NavigationStack {
            VStack {
                // 动画视图
                LottieView(filename: appStorage.LoopAnimation, isPlaying: appStorage.isLoopAnimation, playCount: 0, isReversed: false)
                    .id(appStorage.LoopAnimation)
                    .modifier(LottieModifier())
                    .onTapGesture {
                        appStorage.isLoopAnimation.toggle()
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            isSlientMode = false
                        }
                    }, label: {
                        Image("quit")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 30,height: 30)
                            .scaledToFit()
                            .foregroundColor(buttonColor)
                    })
                    .buttonStyle(.plain)
                }
            }
            .background {
                BackgroundImgView()
            }
            .onAppear {
                // 显示时，设置标志位为 true
                print("静默视图显示，设置 isShowingIdleView = true")
                idleManager.isShowingIdleView = true
            }
            .onDisappear {
                // 隐藏时，设置标志位为 false
                print("静默视图隐藏，设置 isShowingIdleView = false")
                idleManager.isShowingIdleView = false
                idleManager.resetTimer()
            }
        }
    }
}

#Preview {
    SlientMode(isSlientMode: .constant(true))
        .environmentObject(AppStorageManager.shared)
        .environmentObject(IdleTimerManager.shared)
}
