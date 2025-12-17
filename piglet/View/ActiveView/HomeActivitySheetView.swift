//
//  HomeActivitySheetView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct HomeActivitySheetView: View {
    @EnvironmentObject var idleManager: IdleTimerManager
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State private var activityVM = ActiveViewModel()
    @FocusState private var isFocused: Bool
    var body: some View {
        ZStack(alignment: .bottom) {
            // 活动视图
            VStack(alignment: .center,spacing: 0) {
                // 背景图片区域
                ActivitySheetBgView()
                // 内容显示
                ActivityContentView(isFocused: $isFocused)
            }
            // 顶部返回按钮和标题
            HomeActivityTitleView()
        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation {
                isFocused = false
            }
        }
        .environment(activityVM)
        .onAppear {
            // 显示时，设置标志位为 true
            print("显示交易视图，关闭计时器")
            idleManager.isShowingIdleView = true
            idleManager.stopTimer()
        }
        .onDisappear {
            // 隐藏时，设置标志位为 false
            print("关闭交易视图，重启计时器")
            idleManager.isShowingIdleView = false
            idleManager.resetTimer()
        }
    }
}

struct HomeActivityTitleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .fontWeight(.semibold)
            .fixedSize(horizontal: false, vertical: true)
    }
}
struct HomeActivityFootNoteModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.footnote)
            .foregroundColor(AppColor.gray)
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    NavigationStack {
        VStack{}
            .sheet(isPresented: .constant(true)) {
                let hvm = HomeActivityViewModel()
                let vm = ActiveViewModel()
                HomeActivitySheetView()
                    .environment(vm)
                    .environment(hvm)
                    .environment(IdleTimerManager.shared)
                    .onAppear {
                        hvm.tab = .LifePiggy
                    }
            }
            .environment(\.locale, .init(identifier: "ru"))
    }
}
