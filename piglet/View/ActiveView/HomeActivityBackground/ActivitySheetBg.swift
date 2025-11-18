//
//  HomeActivitySheetBackground.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/16.
//

import SwiftUI

struct ActivitySheetBgView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        ZStack {
            // 背景图片
            Rectangle()
                .overlay {
                    // 背景图片
                    Image(activityVM.tab.image)
                        .resizable()
                        .scaledToFill()
                }
                .frame(minHeight: 400)
                .padding(.bottom, -20)
            SheetView()
        }
    }
}

private struct SheetView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        VStack {
            Spacer()
            if activityVM.tab == .EmergencyFund {
                EmergencyFundView()
                    .padding(.bottom,20)
            }
        }
    }
}

#Preview {
    NavigationStack {
        VStack{}
            .sheet(isPresented: .constant(true)) {
                HomeActivitySheetView()
                    .environment(ActiveViewModel())
            }
    }
}

