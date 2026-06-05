//
//  lockApp.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/9.
//
// 显示有锁的内容

import SwiftUI

struct LockApp: View {
    @State private var showPro = false
    @Environment(AppStorageManager.self) var appStorage
    @Environment(IAPManager.self) var iapManager
    var body: some View {
        Button(action: {
            showPro.toggle()
        }, label: {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "lock.fill")
                        .imageScale(.small)
                        .padding(.vertical,6)
                        .padding(.horizontal,10)
                        .foregroundColor(.white)
                        .background(AppColor.appColor)
                        .cornerRadius(5)
                }
            }
            .background {
                Color.black.opacity(0.1).cornerRadius(10)
            }
        })
        .sheet(isPresented: $showPro) {
            ProView(showCloseButton: true)
                .environment(appStorage)
                .environment(iapManager)
        }
    }
}
