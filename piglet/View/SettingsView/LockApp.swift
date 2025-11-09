//
//  lockApp.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/9.
//
// 显示有锁的内容

import SwiftUI

struct LockApp: View {
    var body: some View {
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
    }
}
