//
//  HomeActivitySheetBackground.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct ActivitySheetBgView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var homeActivityVM: HomeActivityViewModel
    @EnvironmentObject var activityVM: ActiveViewModel
    
    var body: some View {
        let imgOpacity = colorScheme == .light ? 0 : 0.3
        ZStack {
            // 背景图片
            ZStack {
                Color.black
                Rectangle()
                    .overlay {
                        // 背景图片
                        Image(homeActivityVM.tab.image)
                            .resizable()
                            .scaledToFill()
                            .overlay {
                                Color.black
                                    .opacity(imgOpacity)
                            }
                    }
                    .frame(minHeight: 400)
                    .padding(.bottom, -20)
            }
            SheetView()
        }
    }
}

private struct SheetView: View {
    @EnvironmentObject var homeActivityVM: HomeActivityViewModel
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        VStack {
            // 人生存钱罐
            if homeActivityVM.tab == .LifeSavingsBank {
                LifeSavingsView()
            } else if homeActivityVM.tab == .EmergencyFund {
                // 生活存钱罐
                EmergencyFundView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        VStack{}
            .sheet(isPresented: .constant(true)) {
                HomeActivitySheetView()
                    .environment(AppStorageManager.shared)
                    .environment(SoundManager.shared)
                    .environment(HomeActivityViewModel())
            }
    }
}

