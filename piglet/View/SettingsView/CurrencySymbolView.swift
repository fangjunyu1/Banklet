//
//  CurrencySymbolView.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/9.
//

import SwiftUI

struct CurrencySymbolView: View {
    @Environment(AppStorageManager.self) var appStorage
    
    private func changeSymbols(currency: Currency) {
        withAnimation {
            appStorage.CurrencySymbol = currency.currencyAbbreviation
        }
        print("当前货币符号:\(appStorage.CurrencySymbol)")
    }
    var body: some View {
        VStack {
            Spacer().frame(height:10)
            // 当前币种
            VStack(spacing: 8) {
                HStack {
                    Text("Current Currency")
                    Text("\(appStorage.CurrencySymbol)")
                }
                .font(.footnote)
                .foregroundColor(.gray)
                Image(appStorage.CurrencySymbol)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 80)
                    .cornerRadius(10)
                Text(LocalizedStringKey(appStorage.CurrencySymbol))
            }
            Spacer().frame(height:20)
            HStack {
                Footnote(text:"All Currencies")
                Spacer()
            }
            // 全部币种
            ScrollView {
                ForEach(Array(currencySymbolList.sorted(by: {$0.currencyAbbreviation < $1.currencyAbbreviation}).enumerated()), id: \.offset) { index, currency in
                    let lastIndex = currencySymbolList.count - 1
                    Button(action: {
                        changeSymbols(currency: currency)
                    }, label: {
                        HStack{
                            Image(currency.currencyAbbreviation)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                            Text(LocalizedStringKey(currency.currencyAbbreviation))
                            Text(currency.currencyAbbreviation)
                            Spacer()
                            if appStorage.CurrencySymbol == currency.currencyAbbreviation {
                                Image(systemName: "checkmark")
                            }
                        }
                        .padding(.vertical,2)
                        .padding(.horizontal,10)
                        .tint(.black)
                    })
                    if lastIndex != index {                        Divider().padding(.leading, 50)
                    }
                }
                .padding(.vertical,10)
                .background(.white)
                .cornerRadius(12)
                .padding(.bottom, 50)
            }
        }
        .navigationTitle("Currency Symbol")
        .modifier(BackgroundModifier())
        .scrollIndicators(.hidden) // 隐藏滚动条
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

#Preview {
    NavigationStack {
        CurrencySymbolView()
            .environment(AppStorageManager.shared)
    }
}
