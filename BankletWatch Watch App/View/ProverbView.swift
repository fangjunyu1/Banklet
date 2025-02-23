//
//  ProverbView.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/20.
//

import SwiftUI

struct ProverbView: View {
    @State private var currentProverb: String = ""
    @State private var lastRandomIndexes: [Int] = [] // 保存最近的随机数
    let maxHistorySize = 5 // 历史记录长度
    
    // 随机生成谚语的方法
    func generateUniqueRandomProverb() -> String {
        let range = 0..<50
        var newIndex: Int
        repeat {
            newIndex = Int.random(in: range)
        } while lastRandomIndexes.contains(newIndex) // 避免重复
        // 更新历史记录
        lastRandomIndexes.append(newIndex)
        if lastRandomIndexes.count > maxHistorySize {
            lastRandomIndexes.removeFirst() // 超出长度限制时移除最旧的
        }
        return "proverb" + "\(newIndex)"
    }

    
    var body: some View {
        VStack {
            Text(LocalizedStringKey(currentProverb))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(20)
        .contentShape(Rectangle())
        .background(Color.black.opacity(0.01)) // 防止VStack被忽视为非交互区域
        .onTapGesture {
            // 点击动画时刷新谚语
            currentProverb = generateUniqueRandomProverb()
        }
        .onAppear {
            // 进入视图时刷新谚语
            currentProverb = generateUniqueRandomProverb()
        }
    }
}

#Preview {
    ProverbView()
}
