//
//  ContentView.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/18.
//

import SwiftUI

struct ContentView: View {    
    var body: some View {
        VStack(spacing: 0) {
            TabView {
                Home()
                ProverbView()
                List()
            }
        }
    }
}

#Preview {
    ContentView()
}
