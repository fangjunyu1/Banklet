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
                // 版本 1 -> 版本 2
                piggyBank.optionalTargetAmount = piggyBank.targetAmount
                piggyBank.optionalInitialAmount = piggyBank.initialAmount
                piggyBank.dataVersion = 2

                hasChanges = true
            case 2:
                // 版本 2 -> 版本 3
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
