//
//  HomePrimaryBankAdvancedFeatures.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/4.
//

import SwiftUI

struct HomePrimaryBankAdvancedFeatures: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var idleManager: IdleTimerManager
    var primaryBank: PiggyBank
    @Binding var showCreateView: Bool
    var geoHeight = 230.0
    func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "y-MM-dd"
            return formatter.string(from: date)
        }
    
    var body: some View {
        let silentImg = colorScheme == .light ? "SilentBlue" : "SilentWhite"
        let rmode: Image.TemplateRenderingMode = colorScheme == .light ? .original : .template
        let progress: Double = primaryBank.progress
        let progressText = primaryBank.progressText
        let lastRecord = primaryBank.records?.max(by: { $0.date < $1.date })
        let lastRecordAmountText = "\(currencySymbol + " " + (lastRecord?.amount.formattedWithTwoDecimalPlaces() ?? ""))"
        let lastRecordDate = formattedDate(lastRecord?.date ?? Date())
        let lastRecordSaveMoneyIcon = lastRecord?.saveMoney ?? true ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill"
        let lastRecordSaveMoneyColor =  lastRecord?.saveMoney ?? true ? AppColor.green : AppColor.red
        GeometryReader { geo in
            let width = geo.frame(in: .global).width
            let smallSize = 60.0
            let largeSize = 120.0
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
                                Text("Create Piggy")
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.vertical,20)
                            .padding(.horizontal,30)
                            .frame(maxWidth: .infinity)
                            .modifier(BlueBgModifier())
                            .cornerRadius(10)
                            .multilineTextAlignment(.center)
                        })
                        .frame(height:smallSize)
                        // 静默模式
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                idleManager.isIdle = true
                            }
                        }, label: {
                            ZStack {
                                VStack {
                                    HStack {
                                        Image(silentImg)
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(.white)
                                        Text("Silent Mode")
                                            .font(.caption2)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .modifier(BlueTextModifier())
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding(10)
                                LottieView(filename: "SilentHouse", isPlaying: true, playCount: 3, isReversed: false)
                                    .scaledToFit()
                                    .frame(height:largeSize * 0.8)
                            }
                            .modifier(WhiteBgModifier())
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
                                Caption2Black(text: "Access progress")
                                Spacer()
                                Text(progressText)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.gray)
                            }
                            GridProgressView(rows: 5, columns: 10,progress: progress,filledColor: .blue)
                        }
                        .padding(10)
                        .frame(height:largeSize)
                        .modifier(WhiteBgModifier())
                        .cornerRadius(10)
                        // 存取记录
                        NavigationLink(destination: AccessTimesView(), label: {
                            VStack(alignment: .leading,spacing: 10) {
                                HStack {
                                    Image("counterclockwise")
                                        .resizable()
                                        .renderingMode(rmode)
                                        .frame(width: 12,height:12)
                                        .foregroundColor(Color.gray)
                                    Caption2Black(text: "Access records")
                                    Spacer()
                                }
                                if let lastRecord{
                                    HStack(spacing:3) {
                                        Caption2(text:"\(lastRecordDate)")
                                        Spacer()
                                        Image(systemName: lastRecordSaveMoneyIcon)
                                            .font(.caption2)
                                            .foregroundColor(lastRecordSaveMoneyColor)
                                        Caption2(text: lastRecordAmountText)
                                    }
                                } else {
                                    Caption2(text:"No records available")
                                }
                            }
                            .padding(10)
                            .frame(height: smallSize)
                            .modifier(WhiteBgModifier())
                            .cornerRadius(10)
                        })
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
