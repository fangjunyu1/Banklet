//
//  HomeViewModel.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/21.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
class HomeViewModel:ObservableObject {
    var isTradeView = false
    var tardeModel:TradeModel = .deposit
    var piggyBank: PiggyBank?
    
    // 删除存钱罐
    func deletePiggyBank(for data: PiggyBank) {
        // Step 1: 获取上下文
        let context = DataController.shared.context
        
        // Step 2: 删除存钱罐
        context.delete(data)
        
        // Step 3: 保存上下文
        do {
            try context.save() // 提交上下文中的所有更改
        } catch {
            print("Fetch failed:", error)
        }
    }

}


enum TradeModel {
    case deposit
    case withdraw
}
