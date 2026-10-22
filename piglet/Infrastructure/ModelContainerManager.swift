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
}
