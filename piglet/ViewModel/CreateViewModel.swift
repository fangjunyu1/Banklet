//
//  CreateViewModel.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class CreateStepViewModel: ObservableObject {
    var tab: CreateStep = .name
    
    func createPiggyBank(for data: PiggyBankData) {
        // Step 1: 获取上下文
        let context = DataController.shared.context
        
        // Step 2: 查询所有存钱罐
        let fetchRequest = FetchDescriptor<PiggyBank>()
        let existingPiggyBanks: [PiggyBank]
        do {
            existingPiggyBanks = try context.fetch(fetchRequest)
        } catch {
            print("Fetch failed:", error)
            return
        }
        
        // Step 3: 将所有存钱罐的 isPrimary 设置为 false
        existingPiggyBanks.forEach { bank in
            bank.isPrimary = false
        }
        
        // Step 4: 创建存钱罐
        let piggyBank = PiggyBank(name: data.name.isEmpty ? "New Banklet" : data.name,
                                  icon: data.icon,
                                  initialAmount:
                                    data.amount ?? 0,
                                  targetAmount: data.targetAmount ?? 1,
                                  amount:
                                    data.amount ?? 0,
                                  creationDate: Date(),
                                  expirationDate: data.expirationDate,
                                  isExpirationDateEnabled: data.isExpirationDateEnabled,
                                  isFixedDeposit: data.isFixedDeposit,
                                  fixedDepositType: data.fixedDepositType,
                                  fixedDepositAmount: data.fixedDepositAmount,
                                  isPrimary: true)
        
        context.insert(piggyBank) // 将对象插入到上下文中
        
        // Step 5: 保存上下文
        do {
            try context.save() // 提交上下文中的所有更改
        } catch {
            print("Fetch failed:", error)
        }
    }
    
    func step() {
        switch self.tab {
        case .name:
            tab = .targetAmount
        case .targetAmount:
            tab = .icon
        case .icon:
            tab = .amount
        case .amount:
            tab = .regular
        case .regular:
            tab = .expirationDate
        case .expirationDate:
            tab = .complete
            // 播放完成音效
            SoundManager.shared.playSound(named: "success")
        case .complete:
            break
        }
    }
    
    func previousStep() {
        switch self.tab {
        case .name:
            break
        case .targetAmount:
            tab = .name
        case .icon:
            tab = .targetAmount
        case .amount:
            tab = .icon
        case .regular:
            tab = .amount
        case .expirationDate:
            tab = .regular
        case .complete:
            tab = .expirationDate
        }
    }
}
