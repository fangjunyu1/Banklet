//
//  generateUniqueRandomProverb.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//
// 随机生成谚语的方法
// 暂时弃用

import SwiftUI

func generateUniqueRandomProverb() -> String {
    
    @State var lastRandomIndexes: [Int] = [] // 保存最近的随机数
    let range = 0..<22
    var newIndex: Int
    let maxHistorySize = 3 // 历史记录长度
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
