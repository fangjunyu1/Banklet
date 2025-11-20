//
//  DataController.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI
import SwiftData

@MainActor
@Observable
final class DataController: ObservableObject {
    static let shared = DataController()
    var container: ModelContainer
    var context: ModelContext { container.mainContext }
    private init() {
        self.container = try! ModelContainer(
            for: PiggyBank.self,
                 SavingsRecord.self,
            configurations: ModelConfigManager.shared.currentConfiguration)
    }
    
    func updateContainer() {
        container = try! ModelContainer(
            for: PiggyBank.self, SavingsRecord.self,
            configurations: ModelConfigManager.shared.currentConfiguration
        )
    }
}
