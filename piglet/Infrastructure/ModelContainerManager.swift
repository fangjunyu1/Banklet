//
//  ModelContainerManager.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI
import SwiftData

@MainActor
@Observable
final class ModelContainerManager: ObservableObject {
    static let shared = ModelContainerManager(
        configurations: ModelConfigManager.shared.currentConfiguration
    )
    
    private init(configurations: ModelConfiguration) {
        print("进入 ModelContainerManager 构造函数")
        container = try! ModelContainer(
            for:PiggyBank.self,
            SavingsRecord.self,
            configurations: configurations
        )
        print("完成 ModelContainerManager 构造函数")
    }
    
    var container: ModelContainer
    var context: ModelContext {
        container.mainContext
    }
    
    func updateContainer() {
        container = try! ModelContainer(
            for: PiggyBank.self, SavingsRecord.self,
            configurations: ModelConfigManager.shared.currentConfiguration
        )
    }
    
    // SwiftData 数据迁移
    func migrateDataIfNeeded() throws {
        let descriptor = FetchDescriptor<PiggyBank>()
        let piggyBanks = try context.fetch(descriptor)
        
        // 统计数据版本
        func printDataVersion(_ title: String) {
            let version1 = piggyBanks.filter { $0.dataVersion == 1 }.count
            let version2 = piggyBanks.filter { $0.dataVersion == 2 }.count
            
            print("\(title) 存钱罐版本 1: \(version1), 版本 2: \(version2)")
        }
        
        printDataVersion("迁移前")
        
        var hasChanges = false
        
        for piggyBank in piggyBanks {
            guard piggyBank.dataVersion < 2 else {
                continue
            }
            
            switch piggyBank.dataVersion {
            case 1:
                
                // MARK: 版本 1 -> 版本 2
                
                print("存钱罐当前金额：\(piggyBank.amount)")
                print("存钱罐初始金额：\(piggyBank.initialAmount)")
                
                // 1. 获取旧版历史记录
                let existingRecords = piggyBank.records ?? []
                
                // 2. 计算历史记录净余额
                let historyBalance = existingRecords.reduce(0.0) {
                    $0 + ($1.saveMoney ? $1.amount : -$1.amount)
                }
                print("存钱罐存取记录 - 历史记录净余额：\(historyBalance)")
                
                // 3. 计算需要补充的校准金额
                let migrationAdjustment = piggyBank.amount - (
                    piggyBank.initialAmount + historyBalance
                )
                
                // 4. 迁移初始金额
                if piggyBank.initialAmount != 0 {
                    print("迁移初始金额: \(piggyBank.initialAmount)，创建一条迁移初始金额记录")
                    let initialRecord = SavingsRecord(
                        amount: abs(piggyBank.initialAmount),
                        date: piggyBank.creationDate,
                        saveMoney: piggyBank.initialAmount > 0,
                        type: .openingBalance,
                        piggyBank: piggyBank
                    )
                    
                    context.insert(initialRecord)
                } else {
                    print("无迁移初始金额")
                }
                
                // 5. 添加迁移校准记录
                if abs(migrationAdjustment) >= 0.01 {
                    print("迁移校准记录金额: \(migrationAdjustment)，创建一条迁移校准记录")
                    let migrationAdjustmentDate = piggyBank.creationDate
                        .addingTimeInterval(1)
                    
                    let adjustmentRecord = SavingsRecord(
                        amount: abs(migrationAdjustment),
                        date: migrationAdjustmentDate,
                        saveMoney: migrationAdjustment > 0,
                        type: .migrationAdjustment,
                        piggyBank: piggyBank
                    )
                    
                    context.insert(adjustmentRecord)
                } else {
                    print("无迁移校准记录金额")
                }
                
                // 6. 迁移目标金额
                piggyBank.optionalTargetAmount = piggyBank.targetAmount
                
                // 7. 迁移到期日期
                piggyBank.optionalExpirationDate = piggyBank.isExpirationDateEnabled
                    ? piggyBank.expirationDate
                    : nil
                
                // 8. 迁移完成日期，遵循旧版完成条件
                if piggyBank.amount >= piggyBank.targetAmount {
                    piggyBank.optionalCompletionDate =  piggyBank.completionDate
                } else {
                    piggyBank.optionalCompletionDate = nil
                }
                
                // 7. 更新数据版本
                piggyBank.dataVersion = 2
                
                hasChanges = true
            case 2:
                // MARK: 版本 2 -> 版本 3
                break
            default:
                break
            }
        }
        
        if hasChanges {
            try context.save()
        }
        
        printDataVersion("迁移后")
    }
}
