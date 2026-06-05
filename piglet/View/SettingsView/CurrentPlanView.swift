//
//  CurrentPlanView.swift
//  piglet
//
//  Created by 方君宇 on 2026/6/4.
//

import SwiftUI

// 当前方案
struct CurrentPlanView: View {
    @Environment(AppStorageManager.self) var appStorage
    
    private var expirationDateString: String {
        Date(timeIntervalSince1970: appStorage.expirationDate)
            .formatted(date: .abbreviated, time: .omitted)
    }
    
    var body: some View {
        VStack {
            // 当前方案
            HStack {
                Footnote(text: "Current Plan")
                Spacer()
            }
            
            if Date(timeIntervalSince1970: appStorage.expirationDate) > Date() {
                HStack {
                    Text("Pro")
                        .fontWeight(.medium)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Expiry date")
                        Text(expirationDateString)
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
                .frame(height: 60)
                .modifier(Pro2Bg())
            }
            
            if appStorage.isLifetime {
                // 终身
                HStack {
                    Text("Pro")
                        .fontWeight(.medium)
                    Spacer()
                    Text("Lifetime")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                .frame(height: 60)
                .modifier(Pro2Bg())
            }
        }
    }
}
