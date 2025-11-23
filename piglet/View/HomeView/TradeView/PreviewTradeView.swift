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
    
    init() {
        self.hvm.piggyBank = PiggyBank(name: "奔驰车", icon: "car", initialAmount: 40000, targetAmount: 380000, amount: 40000, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: true, isPrimary: true)
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
                TradeView()
                    .environmentObject(hvm)
            }
        }
    }
}

#Preview {
    PreviewTradeView()
        .environmentObject(AppStorageManager.shared)
}
