//
//  ContentView.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/18.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            TabView {
                Text("Tab 1")
                    .tabItem {
                        Text("First")
                    }
                Text("Tab 2")
                    .tabItem {
                        Text("Second")
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
