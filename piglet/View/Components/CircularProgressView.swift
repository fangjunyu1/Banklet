//
//  CircularProgressView.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/3.
//

import SwiftUI

struct CircularProgressView: View {
    var primary: PiggyBank
    var size: Double
    var isEdit: Bool
    @Binding var draft: PiggyBankDraft
    @Binding var showIcons: Bool
    var progress: Double {
        primary.progress
    }
    
    var body: some View {
        ZStack {
            ZStack {
                // 背景圆环
                Circle()
                    .stroke(.gray.opacity(0.2), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                
                // 进度圆环
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(.blue, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
            .frame(width: size, height: size)
            .scaleEffect(0.9)
            // 图标
            Button(action:{
                if isEdit { withAnimation { showIcons.toggle() } }
            }, label: {
                Image(systemName: draft.icon)
                    .font(.largeTitle)
                    .foregroundColor(isEdit ? Color.primary : Color.gray)
            })
            .disabled(!isEdit)
        }
    }
}
