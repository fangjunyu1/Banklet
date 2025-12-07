//
//  PreviewTradeView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/22.
//
//  仅用于开发预览，可删除

import SwiftUI

struct PreviewTradeView: View {
    
    @State private var hvm = HomeViewModel()
    @FocusState private var focus: Field?
    init() {
        self.hvm.piggyBank = PiggyBank(name: "奔驰车", icon: "car", initialAmount: 40000, targetAmount: 380000, amount: 40000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isFixedDeposit: false, fixedDepositType: FixedDepositEnum.day.rawValue, isPrimary: true)
    }
    
    var body: some View {
        ZStack {
            ZStack {
                Image("bg0")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) { hvm.isTradeView = true }
                        hvm.tardeModel = .deposit
                    }, label: {
                        Text("存入")
                            .modifier(ButtonModifier())
                    })
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) { hvm.isTradeView = true }
                        hvm.tardeModel = .withdraw
                    }, label: {
                        Text("取出")
                            .modifier(ButtonModifier())
                    })
                }
            }
            .blur(radius: hvm.isTradeView ? 30 : 0)
            if hvm.isTradeView {
                ZStack {
                    
                        // 白色模糊背景
                        Rectangle()
                            .foregroundColor(.white)
                            .ignoresSafeArea()
                            .opacity(0.5)
                            .onTapGesture {
                                focus = nil   // 点击背景，关闭输入框
                            }
                    
                    TradeView(focus: $focus)
                        .transition(.move(edge: .bottom))   // 从底部滑上来
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: hvm.isTradeView)
                        .zIndex(1)
                }
            }
        }
    }
}

#Preview {
    PreviewTradeView()
        .environmentObject(AppStorageManager.shared)
        .environmentObject(HomeViewModel())
}
