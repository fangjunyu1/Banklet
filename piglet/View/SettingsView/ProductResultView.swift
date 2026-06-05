//
//  ProductResultView.swift
//  piglet
//
//  Created by 方君宇 on 2026/6/4.
//

import SwiftUI

struct ProductResultView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @Environment(\.dismiss) var dismiss
    let result: ProductResultEnum
    
    // 当前方案、选择方案的选项高度
    private let buttonHeight: Double = 60
    
    private var expirationDateString: String {
        Self.formatExpirationDate(appStorage.expirationDate)
    }
    
    // 格式化显示日期
    private static func formatExpirationDate(_ timestamp: TimeInterval) -> String {
        Date(timeIntervalSince1970: timestamp)
            .formatted(date: .abbreviated, time: .omitted)
    }
    
    // Lottie 动画
    private var lottieName: String? {
        switch result {
        case .purchaseSuccess, .restoreSuccess:
            "check2026"
        case .purchaseFailed, .restoreFailed:
            "error2026"
        case .stateless:
            nil
        }
    }
    
    // 完成状态
    private var resultName: LocalizedStringKey? {
        switch result {
        case .purchaseSuccess:
            "Purchased"
        case .purchaseFailed:
            "Purchase Failed"
        case .restoreSuccess:
            "Restored"
        case .restoreFailed:
            "Restore Failed"
        case .stateless:
            nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                lottie
                proTitle
                if appStorage.isValidMember {
                    CurrentPlanView()
                        .padding(.top, 20)
                        .padding(.bottom, 50)
                }
                proButton
                Spacer()
            }
            .padding(.top, 50)
        }
        .modifier(BackgroundModifier())
    }
    
    @ViewBuilder
    var lottie: some View {
        // Lottie 动画
        if let lottieName = lottieName {
            LottieView(filename: lottieName, isPlaying: true, playCount: 0, isReversed: false)
                .modifier(LottieModifier())
        }
    }
    
    var proTitle: some View {
        VStack(spacing: 16) {
            // 完成状态
            if let resultName = resultName {
                Text(resultName)
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
            }
            
            // 高级会员
            Text("Pro")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color("AppColor2"))
        }
    }
    
    // 按钮
    var proButton: some View {
        // 完成
        Button(action: {
            // 振动
            HapticManager.shared.selectionChanged()
            dismiss()
        }, label: {
            Text("Completed")
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .foregroundColor(.white)
                .frame(width: 240,height: 60)
                .background(Color(hex: "3477F5"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        })
    }
}
