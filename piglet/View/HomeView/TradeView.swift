//
//  TradeView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/21.
//

import SwiftUI
import StoreKit

struct TradeView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var idleManager: IdleTimerManager
    @EnvironmentObject var appStorage: AppStorageManager
    // 管理存钱/取钱状态和是否显示TradeView
    @EnvironmentObject var homeVM: HomeViewModel
    // 打开存钱/取钱视图时，创建对象并管理金额和备注
    @State private var tradeVM = TradeViewModel()
    @State private var textOffset: CGFloat = 40
    @FocusState var focus: Field?
    
    var showNavigationTitle: Text {
        appStorage.isDebtModel ? Text("Debt Model") : Text(verbatim: "")
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                if homeVM.piggyBank != nil {
                    if tradeVM.tradeStatus == .prepare {
                        // 存钱罐图标
                        piggyBankIconView
                        // 存钱罐名称
                        piggyBankNameView
                    }
                    // 存钱罐交易视图
                    piggyBankContnetView
                    // 存钱罐按钮
                    piggyBankButtonView
                }
                Spacer()
            }
        }
        .toolbar {
            // 完成视图
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Completed")
                        .modifier(BlackTextModifier())
                })
            }
            if appStorage.isDebtModel {
                ToolbarItem(placement: .principal) {
                    Text("Debt Model")
                        .foregroundColor(Color(hex: "FF7D14"))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color(hex: "FF7D14").opacity(0.1))
                        .cornerRadius(8)
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background {
            Background()
        }
        .onAppear {
            focus = .amount
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
    
    // 存钱罐图标
    @ViewBuilder
    var piggyBankIconView: some View {
        if let piggyBank = homeVM.piggyBank {
            ZStack {
                ZStack {
                    // 背景圆环
                    Circle()
                        .stroke(.gray.opacity(0.2), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    
                    // 进度圆环
                    Circle()
                        .trim(from: 0, to: piggyBank.progress)
                        .stroke(.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeInOut(duration: 0.3), value: piggyBank.progress)
                }
                .frame(width: 100, height: 100)
                .scaleEffect(0.9)
                // 图标
                Image(systemName: piggyBank.icon)
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
        }
    }
    
    // 存钱罐名称
    @ViewBuilder
    var piggyBankNameView: some View {
        if let piggyBank = homeVM.piggyBank {
            Text(verbatim: piggyBank.name)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.gray)
                .padding(10)
                .frame(maxWidth: 200)
                .background(Color("AppColor"))
                .cornerRadius(10)
        }
    }
    
    @ViewBuilder
    var piggyBankContnetView: some View {
        switch tradeVM.tradeStatus {
            // 完成存钱
        case .finish:
            VStack(spacing: 10) {
                LottieView(
                    filename: "check1",
                    isPlaying: true,
                    playCount: 1,
                    isReversed: false
                )
                .scaledToFit()
                .scaleEffect(1.2)
                .frame(maxWidth: 100)
                HStack {
                    Text(currencySymbol)
                        .font(.system(size: 45))
                        .fontWeight(.bold)
                        .foregroundColor(AppColor.gray)
                    Text(verbatim: "\(tradeVM.amount?.formatted() ?? "")")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                .frame(width: 230)
                VStack(spacing: 20) {
                    // 存钱时间
                    HStack {
                        Text("Time")
                        Spacer()
                        Text(tradeVM.date ?? Date(), format: Date.FormatStyle.dateTime)
                            .foregroundColor(AppColor.gray)
                    }
                    // 存钱备注
                    if appStorage.isAccessNotes {
                        HStack {
                            Text("Notes")
                            Spacer()
                            if tradeVM.remark.isEmpty {
                                Text("None")
                                    .foregroundColor(AppColor.gray)
                            } else {
                                Text(verbatim: "\(tradeVM.remark)")
                                    .foregroundColor(AppColor.gray)
                            }
                        }
                    }
                }
                .font(.subheadline)
                .padding(.top,10)
                .padding(.horizontal,20)
            }
            // 填写信息
        case .prepare:
            VStack(spacing: 0) {
                HStack(alignment: .center) {
                    VStack {
                        Spacer()
                        // 存取标识
                        Text(homeVM.tardeModel == .deposit ? "Deposit" : "Withdraw")
                            .fontWeight(.medium)
                            .padding(.bottom, 8)
                    }
                    Text(currencySymbol)
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                        .modifier(GrayTextModifier())
                        .offset(x: textOffset)
                        .onChange(of: tradeVM.amount) { _, newAmount in
                            if let amount = newAmount {
                                let length = String(Int(amount)).count
                                print("length:\(length)")
                                if length != 1 {
                                    if length > 3 {
                                        print("金额超过4位数")
                                        textOffset = 0
                                    } else {
                                        print("金额未超过4位数，偏移\(CGFloat(length * -10)),textOffset:\(textOffset)")
                                        textOffset = 40 + CGFloat(length * -10)
                                    }
                                }
                            } else {
                                textOffset = 40
                            }
                        }
                    TextField(value: $tradeVM.amount, format: .number) {
                        Text(verbatim: "_")
                    }
                    .fontWeight(.bold)
                    .font(.system(size: 60))
                    .foregroundColor(AppColor.appColor)
                    .focused($focus, equals: .amount)
                    .frame(width: 140)
                    .keyboardType(.decimalPad)   // 数字 + 小数点键盘
                    .frame(height: 70)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.center)
                    .onChange(of: tradeVM.amount) {
                        // 振动
                        HapticManager.shared.selectionChanged()
                    }
                }
                // 备注
                if appStorage.isAccessNotes {
                    HStack {
                        Text("Notes")
                            .font(.footnote)
                            .modifier(GrayTextModifier())
                        TextField(text: $tradeVM.remark) {
                            Text(verbatim: "")
                        }
                        .font(.footnote)
                        .focused($focus, equals: .note)
                        .onChange(of: tradeVM.remark) {
                            // 振动
                            HapticManager.shared.selectionChanged()
                        }
                        .frame(maxWidth: 300)
                    }
                    .padding(.vertical,8)
                    .padding(.horizontal,10)
                    .background(Color("AppColor"))
                    .cornerRadius(6)
                    .padding(.top,10)
                }
            }
            // 加载状态
        case .loading:
            LottieView(
                filename: "FreeBlueLoadingAnimation",
                isPlaying: true,
                playCount: 0,
                isReversed: false,
                tintColor: colorScheme == .light ? nil : .white)
            .scaledToFit()
            .scaleEffect(1.5)
            .frame(maxWidth: 100)
        }
    }
    
    var piggyBankButtonView: some View {
        // 存钱按钮
        VStack(spacing: 20) {
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                // 取消输入框焦点
                focus = nil
                // 根据存钱状态，调用方法
                switch tradeVM.tradeStatus {
                case .prepare:
                    tradeVM.tradeAmount(piggyBank: homeVM.piggyBank, tardeModel: homeVM.tardeModel)
                case .finish:
                    homeVM.isTradeView = false
                    // 评分弹窗
                    if !appStorage.isRatingWindow {
                        SKStoreReviewController.requestReview()
                        appStorage.isRatingWindow = true
                    } else {
                        print("已经弹出过评分弹窗，不再设置")
                    }
                case .loading:
                    break
                }
            }, label: {
                switch tradeVM.tradeStatus {
                case .prepare:
                    Text(homeVM.tardeModel == .deposit ? "Deposit" : "Withdraw")
                        .modifier(ButtonModifier(disableStats: tradeVM.amount == nil))
                case .loading:
                    Text(homeVM.tardeModel == .deposit ? "Deposit" : "Withdraw")
                        .modifier(ButtonModifier())
                case .finish:
                    Text("Completed")
                        .modifier(ButtonModifier())
                }
            })
            .disabled(tradeVM.tradeStatus == .loading ? true : false )
            .disabled(tradeVM.amount == nil)
            
            // 取消按钮
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                
                UIView.animate(withDuration: 0.3) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                
                homeVM.isTradeView = false
                // 取消任务
                tradeVM.cancelTask()
            }, label: {
                Text("Closure")
                    .modifier(GrayTextModifier())
            })
            .opacity(tradeVM.tradeStatus != .finish ? 1 : 0)
        }
    }
}

enum Field {
    case amount
    case note
}
