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
    @FocusState private var focus: Field?
    
    private var tradeTitle: LocalizedStringKey {
        homeVM.tardeModel == .deposit ? "Deposit" : "Withdraw"
    }
    
    var body: some View {
        ZStack {
            Background()
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 22) {
                    if let piggyBank = homeVM.piggyBank {
                        switch tradeVM.tradeStatus {
                        case .prepare:
                            // 存钱信息
                            prepareContent(piggyBank: piggyBank)
                            
                        case .loading:
                            loadingContent
                            
                        case .finish:
                            finishContent
                        }
                    }
                    Spacer()
                    piggyBankButtonView
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .padding(.bottom, 12)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 120)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Text("Completed")
                        .modifier(BlackTextModifier())
                }
            }
            
            if appStorage.isDebtModel {
                ToolbarItem(placement: .principal) {
                    Text("Debt Model")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "FF7D14"))
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                        .background(Color(hex: "FF7D14").opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button {
                    focus = nil
                } label: {
                    Text("Completed")
                        .modifier(BlackTextModifier())
                }
            }
        }
        .onAppear {
            focus = .amount
            
            print("显示交易视图，关闭计时器")
            idleManager.isShowingIdleView = true
            idleManager.stopTimer()
        }
        .onDisappear {
            print("关闭交易视图，重启计时器")
            idleManager.isShowingIdleView = false
            idleManager.resetTimer()
        }
    }
    
    @ViewBuilder
    private func prepareContent(piggyBank: PiggyBank) -> some View {
        VStack(spacing: 20) {
            // 存钱罐图标、名称和存入/取出状态
            piggyBankHeaderView(piggyBank: piggyBank)
            // 存钱输入框
            amountInputCard
            
            if appStorage.isAccessNotes {
                noteInputCard
            }
        }
    }
    
    private func piggyBankHeaderView(piggyBank: PiggyBank) -> some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .stroke(.gray.opacity(0.16), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                
                Circle()
                    .trim(from: 0, to: piggyBank.progress)
                    .stroke(AppColor.appColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: piggyBank.progress)
                
                Image(systemName: piggyBank.icon)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(AppColor.gray)
            }
            .frame(width: 86, height: 86)
            
            Text(LocalizedStringKey(piggyBank.name))
                .font(.headline)
                .foregroundColor(AppColor.gray)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Text(tradeTitle)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(AppColor.appColor)
                .padding(.vertical, 5)
                .padding(.horizontal, 12)
                .background(AppColor.appColor.opacity(0.12))
                .clipShape(Capsule())
        }
        .frame(maxWidth: .infinity)
    }
    
    private var amountInputCard: some View {
        VStack(spacing: 14) {
            HStack {
                Text("Amount")
                    .font(.footnote)
                    .modifier(GrayTextModifier())
                Spacer()
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(Currency.currencySymbol)
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(AppColor.gray)
                    .frame(height: 30)
                
                TextField(value: $tradeVM.amount, format: .number) {
                    Text(verbatim: "0")
                }
                .font(.system(size: 58, weight: .bold))
                .foregroundColor(AppColor.appColor)
                .focused($focus, equals: .amount)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .minimumScaleFactor(0.45)
                .frame(minWidth: 120)
                .onChange(of: tradeVM.amount) {
                    HapticManager.shared.selectionChanged()
                }
                .frame(height: 50)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
        }
        .padding(.vertical, 28)
        .padding(.horizontal, 20)
        .background(Color("AppColor"))
        .cornerRadius(24)
    }
    
    private var noteInputCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Notes")
                .font(.footnote)
                .modifier(GrayTextModifier())
            
            TextField(text: $tradeVM.remark) {
                Text("Add notes")
                    .foregroundColor(.gray.opacity(0.5))
            }
            .font(.body)
            .focused($focus, equals: .note)
            .onChange(of: tradeVM.remark) {
                HapticManager.shared.selectionChanged()
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("AppColor"))
        .cornerRadius(18)
    }
    
    private var loadingContent: some View {
        VStack(spacing: 16) {
            LottieView(
                filename: "FreeBlueLoadingAnimation",
                isPlaying: true,
                playCount: 0,
                isReversed: false,
                tintColor: colorScheme == .light ? nil : .white
            )
            .scaledToFit()
            .scaleEffect(1.3)
            .frame(maxWidth: 100)
            
            Text(homeVM.tardeModel == .deposit ? "Depositing..." : "Withdrawing...")
                .font(.subheadline)
                .modifier(GrayTextModifier())
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
        .padding(.horizontal, 20)
        .background(Color("AppColor"))
        .cornerRadius(24)
    }
    
    private var finishContent: some View {
        VStack(spacing: 22) {
            LottieView(
                filename: "check1",
                isPlaying: true,
                playCount: 1,
                isReversed: false
            )
            .scaledToFit()
            .scaleEffect(1.15)
            .frame(maxWidth: 100)
            
            VStack(spacing: 8) {
                Text("Completed")
                    .font(.headline)
                
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(Currency.currencySymbol)
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(AppColor.gray)
                    
                    Text(verbatim: "\(tradeVM.amount?.formatted() ?? "")")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(AppColor.appColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
            }
            
            VStack(spacing: 14) {
                resultRow(title: "Time") {
                    Text(tradeVM.date ?? Date(), format: Date.FormatStyle.dateTime)
                        .foregroundColor(AppColor.gray)
                }
                
                if appStorage.isAccessNotes {
                    resultRow(title: "Notes") {
                        if tradeVM.remark.isEmpty {
                            Text("None")
                                .foregroundColor(AppColor.gray)
                                .lineLimit(2)
                        } else {
                            Text(verbatim: tradeVM.remark)
                                .foregroundColor(AppColor.gray)
                                .lineLimit(2)
                        }
                    }
                }
            }
            .font(.subheadline)
        }
        .padding(.vertical, 34)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(Color("AppColor"))
        .cornerRadius(24)
    }
    
    private func resultRow<Content: View>(
        title: LocalizedStringKey,
        @ViewBuilder content: () -> Content
    ) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .modifier(GrayTextModifier())
            
            Spacer()
            
            content()
                .multilineTextAlignment(.trailing)
        }
    }
    
    private var piggyBankButtonView: some View {
        VStack(spacing: 14) {
            Button {
                HapticManager.shared.selectionChanged()
                focus = nil
                
                switch tradeVM.tradeStatus {
                case .prepare:
                    tradeVM.tradeAmount(
                        piggyBank: homeVM.piggyBank,
                        tardeModel: homeVM.tardeModel
                    )
                    
                case .finish:
                    homeVM.isTradeView = false
                    
                    if !appStorage.isRatingWindow {
                        SKStoreReviewController.requestReview()
                        appStorage.isRatingWindow = true
                    } else {
                        print("已经弹出过评分弹窗，不再设置")
                    }
                    
                case .loading:
                    break
                }
            } label: {
                switch tradeVM.tradeStatus {
                case .prepare:
                    Text(tradeTitle)
                        .modifier(ButtonModifier(disableStats: tradeVM.amount == nil))
                    
                case .loading:
                    Text(tradeTitle)
                        .modifier(ButtonModifier())
                    
                case .finish:
                    Text("Completed")
                        .modifier(ButtonModifier())
                }
            }
            .disabled(
                tradeVM.tradeStatus == .loading ||
                (tradeVM.tradeStatus == .prepare && tradeVM.amount == nil && tradeVM.amount == 0)
            )
            
            if tradeVM.tradeStatus != .finish {
                Button {
                    HapticManager.shared.selectionChanged()
                    focus = nil
                    homeVM.isTradeView = false
                    tradeVM.cancelTask()
                } label: {
                    Text("Cancel")
                        .font(.subheadline)
                        .modifier(GrayTextModifier())
                }
            }
        }
    }
}

enum Field {
    case amount
    case note
}
