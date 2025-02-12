//
//  CurrencySymbolView.swift
//  piglet
//
//  Created by 方君宇 on 2025/2/9.
//

import SwiftUI

struct CurrencySymbolView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    // 货币符号
    @AppStorage("CurrencySymbol") var CurrencySymbol = "USD"
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                List {
                    ForEach(currencySymbolList.sorted(by: {$0.currencyAbbreviation < $1.currencyAbbreviation}), id: \.self) { currency in
                        Button(action: {
                            CurrencySymbol = currency.currencyAbbreviation
                            print("当前货币符号:\(CurrencySymbol)")
                        }, label: {
                            HStack{
                                Image(currency.currencyAbbreviation)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30)
                                Text(LocalizedStringKey(currency.currencyAbbreviation))
                                Text(currency.currencyAbbreviation)
                                Spacer()
                                if CurrencySymbol == currency.currencyAbbreviation {
                                    Image(systemName: "checkmark")
                                }
                            }
                            .tint(colorScheme == .dark ? Color.white : Color.black)
                        })
                    }
                }
                .navigationTitle("Currency Symbol")
                .navigationBarTitleDisplayMode(.inline)
                .scrollIndicators(.hidden) // 隐藏滚动条
            }
        }
        .onAppear {
            print("当前货币符号:\(CurrencySymbol)")
        }
    }
}

#Preview {
    CurrencySymbolView()
}
