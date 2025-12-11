//
//  SavingsScheduler.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/11.
//

import Foundation
import SwiftData

// 计算下一次存钱周期的方法
@MainActor
struct SavingsScheduler {
    static func calculateNextDate(type:String,
                                  lastDate: Date,
                                  weekday: Int?,
                                  day: Int?) -> Date {
        
        let calendar = Calendar.current
        let enumType = FixedDepositEnum(rawValue: type) ?? .day
        
        // 非每日定期存款的组件
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        components.second = 0
        
        switch enumType {
        case .day:
            components.hour = calendar.component(.hour, from: lastDate)
            components.minute = calendar.component(.minute, from: lastDate)
        case .week:
            components.weekday = weekday
        case .month:
            components.day = day
        case .year:
            let month = calendar.component(.month, from: lastDate)
            let day = calendar.component(.day, from: lastDate)
            components.month = month
            components.day = day
        }
        
        let nextDate = calendar.nextDate(after: lastDate,
                                         matching: components,
                                         matchingPolicy: .previousTimePreservingSmallerComponents,
                                         repeatedTimePolicy: .first,
                                         direction: .forward)
        return nextDate ?? Date()
    }
    
    static func processAutoDeposits(context: ModelContext,piggyBank: [PiggyBank]) {
        let now = Date()
        var hasChanges = false // 标记是否有数据变更
        
        // 遍历每一个存钱罐
        for bank in piggyBank {
            // 1、如果没有启用定期存款，则跳过
            guard bank.isFixedDeposit else { continue }
            
            // 2、如果还没到时间，则跳过
            var nextDate = bank.nextDepositDate
            if nextDate > now { continue}
            
            // 4、遍历循环
            // 如果处理时间早于或等于现在，则循环执行
            while nextDate <= now {
                
                // 5、更新存钱罐和存取记录
                print("执行定期存款，存钱罐名称:\(bank.name) - 时间:\(nextDate.formatted())")
                updateDepositsAndRecords(piggyBank: bank, date: nextDate,context: context)
                hasChanges = true
                
                // 6、计算下一次
                let newDate = calculateNextDate(type: bank.fixedDepositType, lastDate: nextDate, weekday: bank.fixedDepositWeekday, day: bank.fixedDepositDay)
                
                // 更新存钱罐的下一次执行时间
                bank.nextDepositDate = newDate
                nextDate = newDate
            }
        }
        
        // 5、保存数据库
        if hasChanges {
            do {
                try context.save()
                print("所有自动存款处理完毕并保存")
            } catch {
                print("保存失败")
            }
        }
    }
    
    // 定期存钱逻辑
    static func updateDepositsAndRecords(piggyBank:PiggyBank, date: Date, context: ModelContext) {
        // 更新存钱罐金额
        piggyBank.amount = piggyBank.fixedDepositAmount + piggyBank.amount
        
        // 如果存入金额大于目标金额，标记完成时间
        if piggyBank.amount >= piggyBank.targetAmount {
            piggyBank.completionDate = Date()
        }
        
        // 创建存钱记录
        let record = SavingsRecord(
            amount: piggyBank.fixedDepositAmount,
            date: date,
            saveMoney: true,
            note: nil,
            piggyBank: piggyBank,
            type: SavingsRecordType.automatic.rawValue
        )
        context.insert(record)
        
    }
}
