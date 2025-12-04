//
//  TradeViewModel.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/21.
//
//  存入/取出金额视图

import SwiftUI
import SwiftData

@Observable
@MainActor
class TradeViewModel:ObservableObject {
    var amount: Double?
    var remark: String = ""
    var date: Date?
    var tradeStatus: TradeStatus = .prepare
    let context = DataController.shared.context
    var tradeTask: Task<Void,Never>?
    
    func tradeAmount(piggyBank: PiggyBank?,tardeModel: TradeModel) {
        tradeTask?.cancel() // 如果有正在进行的任务，先取消
        
        tradeTask = Task {
            await tradeFlow(piggyBank: piggyBank, tardeModel: tardeModel)
            
        }
    }
    
    func cancelTask() {
        print("取消任务")
        tradeTask?.cancel()
    }
    
    func tradeFlow(piggyBank: PiggyBank?, tardeModel: TradeModel) async {
        guard let piggyBank else {
            print("没有存钱罐")
            return
        }
        guard let amount = amount else {
            print("没有输入任何金额")
            return
        }
        guard amount > 0 else {
            print("输入为0，或小于0，不处理")
            return
        }
        
        // 显示等待动画
        tradeStatus = .loading
        let random = Double.random(in: 2...6)
        print("随机延时:\(random)秒")
        do {
            try await Task.sleep(for: .seconds(random))
        } catch {
            print("任务被取消")
            return
        }
        
        // 计算交易金额
        switch tardeModel {
        case .deposit:
            deposit(piggyBank: piggyBank)
        case .withdraw:
            takeOut(piggyBank: piggyBank)
        }
        
        // 进入完成界面
        self.tradeStatus = .finish
        // 返回成功振动效果
        HapticManager.shared.success()
        // 播放金额音效
        SoundManager.shared.playSound(named: "money1")
    }
    // 存钱逻辑
    func deposit(piggyBank: PiggyBank) {
        // 如果有存入金额
        if let depositAmount = amount {
            // 更新存钱罐的金额，允许超出金额
            print("本次存钱金额:\(depositAmount)，当前金额:\(piggyBank.amount)")
            piggyBank.amount = depositAmount + piggyBank.amount
            // 创建存钱记录
            createRecord(piggyBank: piggyBank, saveMoney: true)
            print("本次存钱后的金额:\(piggyBank.amount)")
        } else {
            print("没有存钱")
        }
    }
    
    // 取钱逻辑
    func takeOut(piggyBank: PiggyBank) {
        // 如果有取款金额
        if let takeOutAmount = amount {
            print("当前金额：\(piggyBank.amount),取出金额:\(takeOutAmount)")
            // 如果开启负债模式，允许存钱罐为负数，否则存钱罐金额最小值为0
            if AppStorageManager.shared.isDebtModel {
                print("当前为负债模式")
                piggyBank.amount = piggyBank.amount - takeOutAmount
                
                // 创建存钱记录
                createRecord(piggyBank: piggyBank, saveMoney: false)
                
                print("取出后的金额:\(piggyBank.amount)")
            } else {
                // 如果不是负债模式
                // 如果当前取出的金额，超出存钱罐金额，显示为0
                if piggyBank.amount - takeOutAmount < 0 {
                    
                    // 创建存钱记录
                    createRecord(piggyBank: piggyBank, saveMoney: false)
                    
                    print("取出金额超过当前金额，当前金额为0")
                    piggyBank.amount = 0
                } else {
                    piggyBank.amount = piggyBank.amount - takeOutAmount
                    // 创建存钱记录
                    createRecord(piggyBank: piggyBank, saveMoney: false)
                    
                    print("取出金额小于当前金额，当前金额:\(piggyBank.amount)")
                }
            }
        } else {
            print("没有取钱")
        }
    }
    
    func createRecord(piggyBank:PiggyBank?,saveMoney: Bool) {
        // 创建存钱记录
        let recprd = SavingsRecord(amount: amount ?? 0, date: Date(), saveMoney: saveMoney, note: remark.isEmpty ? nil : remark, piggyBank: piggyBank)
            context.insert(recprd) // 将对象插入到上下文中
        
        // 如果存入金额大于目标金额，标记完成时间
        if let piggyBank = piggyBank,piggyBank.amount > piggyBank.targetAmount {
            piggyBank.completionDate = Date()
        }
        do {
            try context.save() // 提交上下文中的所有更改
        } catch {
            print("保存失败: \(error)")
        }
    }
    
    enum TradeStatus {
        case prepare
        case loading
        case finish
    }
}
