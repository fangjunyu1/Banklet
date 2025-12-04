//
//  HomePrimaryBankAdvancedFeatures.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/4.
//

import SwiftUI

struct HomePrimaryBankAdvancedFeatures: View {
    var primaryBank: PiggyBank
    @Binding var showCreateView: Bool
    var progress: Double {
        primaryBank.progress
    }
    var geoHeight = 210.0
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.frame(in: .global).width
            let smallSize = 60.0
            let largeSize = 130.0
            let spacing = 15.0
            VStack(alignment: .leading) {
                Footnote(text: "Advanced features")
                HStack {
                    // 创建存钱罐、存取金额
                    VStack(spacing: spacing) {
                        Button(action: {
                            // 振动
                            HapticManager.shared.selectionChanged()
                            showCreateView = true
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Create a piggy bank")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical,20)
                            .padding(.horizontal,30)
                            .frame(maxWidth: .infinity)
                            .background(AppColor.appColor)
                            .cornerRadius(10)
                        })
                        .frame(height:smallSize)
                        
                        Button(action: {
                            
                        }, label: {
                            ZStack {
                                VStack {
                                    HStack {
                                        Text("Silent Mode")
                                            .foregroundColor(AppColor.appColor)
                                            .font(.subheadline)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(10)
                                LottieView(filename: "SilentHouse", isPlaying: true, playCount: 3, isReversed: false)
                                    .scaledToFit()
                                    .frame(height:largeSize * 0.8)
                            }
                            .background(Color.white)
                            .frame(height:largeSize)
                            .cornerRadius(10)
                        })
                    }
                    .frame(width: width * 0.49)
                    // 存取方格和存取记录
                    VStack(spacing: spacing) {
                        // 进度占比-方格
                        VStack(alignment: .leading, spacing:10) {
                            HStack(spacing: 5) {
                                Image(systemName:"calendar")
                                    .foregroundColor(Color.gray)
                                    .imageScale(.small)
                                Caption2(text: "Access progress")
                                Spacer()
                                Text(primaryBank.progressText)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray)
                            }
                            GridProgressView(rows: 5, columns: 10,progress: progress,filledColor: .blue)
                        }
                        .padding(.vertical,10)
                        .padding(.horizontal,10)
                        .frame(height:largeSize)
                        .background(.white)
                        .cornerRadius(10)
                        VStack {
                            
                        }
                        .frame(height: smallSize)
                    }
                    .frame(width: width * 0.49)
                }
            }
        }
        .frame(height:geoHeight)
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
