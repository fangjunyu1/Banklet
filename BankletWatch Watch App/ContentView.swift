//
//  ContentView.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/18.
//

import SwiftUI

struct ContentView: View {
    // 存储接收到的数据
    @State private var piggyBanks = PiggyBankViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            TabView {
                Home()
                ProverbView()
                List()
            }
            .environment(piggyBanks)
        }
        .onAppear {
            // 从UserDefaults中获取iOS数据
            print("从UserDefaults中获取iOS数据")
            piggyBanks.loadPiggyBankDataFromAppGroup()
        }
    }
}

#Preview {
    ContentView()
}
