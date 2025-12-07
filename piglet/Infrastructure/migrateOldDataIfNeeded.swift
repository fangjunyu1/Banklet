//
//  migrateOldDataIfNeeded.swift
//  piglet
//
//  Created by 方君宇 on 2025/10/30.
//
// 1.0.1最早版本的迁移代码，暂时留存，不再使用。

import SwiftUI
import SwiftData

struct migrateOldData: View {
    @Environment(\.modelContext) private var modelContext
    
    
    // 1.0.1 使用UserDefault存储的内容，下面是迁移代码
    func migrateOldDataIfNeeded() {
        let userDefaults = UserDefaults.standard
        
        // 检查是否已有迁移标记
        if userDefaults.bool(forKey: "hasMigratedToSwiftData") {
            print("数据已迁移，无需重复操作")
            return
        }
        
        // 加载旧数据
    //        let currentStep = userDefaults.integer(forKey: "currentStep")
        let pigLetName = userDefaults.string(forKey: "pigLetName") ?? ""
        let pigLettarget = userDefaults.double(forKey: "pigLettarget")
        let pigLetCount = userDefaults.double(forKey: "pigLetCount")
        
        
        // 检查是否有有效数据
        if !pigLetName.isEmpty || pigLettarget > 0 || pigLetCount > 0 {
            // Step 1: 查询所有存钱罐
            let fetchRequest = FetchDescriptor<PiggyBank>()
            let existingPiggyBanks = try? modelContext.fetch(fetchRequest)
            
            // Step 2: 将所有存钱罐的 isPrimary 设置为 false
            existingPiggyBanks?.forEach { bank in
                bank.isPrimary = false
            }
            
            // 将旧数据保存到 SwiftData 模型
            let newPiggyBank = PiggyBank(name: pigLetName, icon: "apple.logo", initialAmount: pigLetCount, targetAmount: pigLettarget, amount: pigLetCount, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: false, isFixedDeposit: false, fixedDepositType: FixedDepositEnum.day.rawValue, fixedDepositAmount: 0,isPrimary: true)
            
            modelContext.insert(newPiggyBank)
            
            do {
                // 保存到数据库
                try modelContext.save()
                print("数据迁移成功！")
                
                // 设置迁移标记
                userDefaults.set(true, forKey: "hasMigratedToSwiftData")
                
                // 清理UserDefaults中的旧值
                clearOldData()
            } catch {
                print("数据迁移失败：\(error.localizedDescription)")
            }
        } else {
            print("没有可迁移的旧数据")
        }
    }

    // 清理 1.1.0 版本之前，已经被弃用的代码
    func clearOldData() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "currentStep")
        userDefaults.removeObject(forKey: "pigLetName")
        userDefaults.removeObject(forKey: "pigLettarget")
        userDefaults.removeObject(forKey: "pigLetCount")
        print("旧数据已清理")
    }

    var body: some View {
        EmptyView()
    }
}
