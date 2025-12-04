//
//  HomeprimaryBankView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomePrimaryBankView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var showMoreInformation = false
    var primaryBank: PiggyBank
    var progress: Double {
        primaryBank.progress
    }
    
    var body: some View {
        // 主存钱罐信息
        VStack(spacing: 10) {
            // 1、主存钱罐当前金额、金额、图标、名称
            HomePrimaryBankTitleView(primaryBank: primaryBank,showMoreInformation: $showMoreInformation)
            Spacer().frame(height:10)
            // 2、Lottie 动画
            LottieView(filename: appStorage.LoopAnimation, isPlaying: appStorage.isLoopAnimation, playCount: 0, isReversed: false)
                .id(appStorage.LoopAnimation)
                .scaledToFit()
                .frame(maxWidth: 160)
                .onTapGesture {
                    appStorage.isLoopAnimation.toggle()
                }
            // 3、主存钱罐信息、存入、取出、删除视图
            HomePrimaryBankButtonView(primaryBank: primaryBank, showMoreInformation: $showMoreInformation)
                .padding(.top,20)
                .padding(.vertical,20)
            // 1、主存钱罐图标、名称、截止日期和进度
            HStack {
                // 存钱罐图标
                ZStack {
                    Rectangle().foregroundStyle(AppColor.appColor)
                    Image(systemName:primaryBank.icon)
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 50)
                .cornerRadius(10)
                Spacer().frame(width: 10)
                VStack(alignment: .leading,spacing: 10) {
                    // 存钱罐名称
                    Text(LocalizedStringKey(primaryBank.name))
                        .fontWeight(.semibold)
                    // 如果设置了截止日期，则显示截止日期
                    if primaryBank.isExpirationDateEnabled {
                        HStack {
                            Text("Expiration date")
                            Text(primaryBank.expirationDate,format: .dateTime.year().month().day())
                        }
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    }
                }
                Spacer()
                // 右上角的百分比进度
                VStack {
                    Text(primaryBank.progressText)
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                }
            }
            .frame(height:50)
            // 2、主存钱罐进度条
            VStack {
                // 金额对比
                HStack(spacing: 5) {
                    // 当前金额
                    Text(primaryBank.amountText)
                    .font(.headline)
                    // 目标金额
                    Group {
                        Text("/")
                        Text(primaryBank.targetAmountText)
                    }
                    .font(.caption2)
                    .foregroundColor(AppColor.appGrayColor)
                    .offset(y:2)
                    Spacer()
                }
                // 2、进度条
                ProgressView(value: progress)
                    .progressViewStyle(CustomProgressViewStyle())
                    .cornerRadius(10)
            }
            // 3、进度占比-方格
            HStack {
                GridProgressView(rows: 5, columns: 7,progress: progress,filledColor: .blue)
            }
            Spacer().frame(height: 5)
        }
        .padding(20)
        .sheet(isPresented: $showMoreInformation) {
            NavigationStack {
                HomeMoreInformationView(primary: primaryBank)
            }
        }
    }
}

#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
