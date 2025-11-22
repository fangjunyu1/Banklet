//
//  HomeViewModel.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/21.
//

import SwiftUI
import SwiftData

extension Bool: Comparable {
    public static func < (lhs: Bool, rhs: Bool) -> Bool {
        // 定义 false 小于 true (即 0 < 1)
        return !lhs && rhs
    }
}

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
        
        // Step 2: 判断是否为主存钱罐
        let wasPrimary = data.isPrimary
        
        // Step 3: 删除存钱罐
        context.delete(data)
        
        // Step 4: 重新制定主存钱罐
        if wasPrimary {
            let fetchRequest = FetchDescriptor<PiggyBank>(
                sortBy: [
                    SortDescriptor(\.isPrimary, order: .reverse),
                    SortDescriptor(\.creationDate, order: .reverse)
                ]
            )
            var existingPiggyBanks: [PiggyBank]
            do {
                existingPiggyBanks = try context.fetch(fetchRequest)
                
                // Step 5: 设置第一个存钱罐为主存钱罐
                existingPiggyBanks.first?.isPrimary = true
            } catch {
                print("无法捕获存钱罐数据")
                return
            }
        }
        
        // Step 6: 保存上下文
        do {
            try context.save() // 提交上下文中的所有更改
        } catch {
            print("Fetch failed:", error)
        }
    }

    func setPiggyBank(for data: PiggyBank) {
        // Step 1: 获取上下文
        let context = DataController.shared.context
        
        // Step 2: 设置或查询描述符
        let fetchRequest = FetchDescriptor<PiggyBank>()
        var existingPiggyBanks: [PiggyBank]
        do {
            existingPiggyBanks = try context.fetch(fetchRequest)
        } catch {
            print("无法捕获存钱罐数据")
            return
        }
        
        // Step 3: 移除其他存钱罐的主存钱罐标识
        existingPiggyBanks.forEach { $0.isPrimary = false}
        print("移除所有存钱罐的主存钱罐标识，当前有无存钱罐标识:\(existingPiggyBanks.contains { $0.isPrimary == true})")
        
        // Spte 4: 设置当前存钱罐的主存钱罐标识
        data.isPrimary = true
        print("设置当前存钱罐为主存钱罐标识")
        // Step 3: 保存上下文
        do {
            try context.save() // 提交上下文中的所有更改
        } catch {
            print("Fetch failed:", error)
            return
        }
    }
}


enum TradeModel {
    case deposit
    case withdraw
}
