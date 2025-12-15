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
    
    // 计算最近的一次定期存款时间
    static func nearestFutureDailyTime(draft: PiggyBankDraft ) -> Date {
        let now = Date()
        let calendar = Calendar.current
        let enumType = FixedDepositEnum(rawValue: draft.fixedDepositType) ?? .Daily
        
        // 用户的最近存取时间可能是很久之前的时间,提取当前用户选择的 时-分 组件
        var userComponents = calendar.dateComponents([.hour, .minute], from: draft.fixedDepositTime)
        
        // 判断用户的存取类型
        switch enumType {
        case .Daily:
            guard let todayAtUserTime = calendar.date(
                bySettingHour: userComponents.hour ?? 0,
                minute: userComponents.minute ?? 0,
                second: 0,
                of: now
            ) else {
                return Date()
            }
            // 如果今天的存取时间大于现在的时间，返回今天的存取时间
            if todayAtUserTime > now {
                return todayAtUserTime
            } else {
                // 否则，今天的存取时间过时，计算下一次存取时间。
                return calculateNextDate(type: draft.fixedDepositType, lastDate: todayAtUserTime, weekday: draft.fixedDepositWeekday, day: draft.fixedDepositDay)
            }
        case .Weekly:
            guard let todayAt9AM = calendar.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: now
            ) else {
                return Date()
            }
            
            // 提取今天的星期
            let todayWeekday = calendar.component(.weekday, from: todayAt9AM)
            // 如果今天的星期和用户选择的星期一样，则检查时间。
            if todayWeekday + 1 == draft.fixedDepositWeekday && todayAt9AM > now {
                // 判断今天的存取时间是否大于现在的时间
                return todayAt9AM
            } else {
                // 否则计算下一个周期
                return calculateNextDate(
                    type: draft.fixedDepositType,
                    lastDate: todayAt9AM,
                    weekday: draft.fixedDepositWeekday,
                    day: draft.fixedDepositDay
                )
            }
        case .Monthly:
            guard let todayAt9AM = calendar.date(
                bySettingHour: 9,
                minute: 0,
                second: 0,
                of: now
            ) else {
                return Date()
            }
            
            let todayDay = calendar.component(.day, from: todayAt9AM)
            
            // 如果今天的几号和用户选择的几号一样，则检查时间。
            if todayDay == draft.fixedDepositDay && todayAt9AM > now{
                // 判断今天的存取时间是否大于现在的时间
                return todayAt9AM
            } else {
                // 否则计算下一个周期
                return calculateNextDate(
                    type: draft.fixedDepositType,
                    lastDate: todayAt9AM,
                    weekday: draft.fixedDepositWeekday,
                    day: draft.fixedDepositDay
                )
            }
        case .Yearly:
            let targetComponents = calendar.dateComponents([.month, .day], from: draft.fixedDepositTime)
            let currentYear = calendar.component(.year, from: now)
            
            var yearComponents = DateComponents()
            yearComponents.year = currentYear
            yearComponents.month = targetComponents.month
            yearComponents.day = targetComponents.day
            yearComponents.hour = 9
            yearComponents.minute = 0
            yearComponents.second = 0
            
            guard let thisYearTime = calendar.date(from: yearComponents) else {
                return Date()
            }
            
            if thisYearTime > now {
                return thisYearTime
            } else {
                return calculateNextDate(
                    type: draft.fixedDepositType,
                    lastDate: thisYearTime,
                    weekday: draft.fixedDepositWeekday,
                    day: draft.fixedDepositDay
                )
            }
            
        }
    }
    
    // 计算下一次定期存款时间
    static func calculateNextDate(type: String,
                                  lastDate: Date,
                                  weekday: Int?,
                                  day: Int?) -> Date {
        
        let calendar = Calendar.current
        let enumType = FixedDepositEnum(rawValue: type) ?? .Daily
        print("存款类型:\(enumType.rawValue)")
        // 非每日定期存款的组件
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        components.second = 0
        
        switch enumType {
        case .Daily:
            print("当日存款，更新为选中的时间")
            components.hour = calendar.component(.hour, from: lastDate)
            components.minute = calendar.component(.minute, from: lastDate)
            print("当前存钱罐组件时间为:\(components)")
        case .Weekly:
            components.weekday = weekday
        case .Monthly:
            components.day = day
        case .Yearly:
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
            
            print("存钱罐:\(bank)，启用定期存款，进入定期存款逻辑")
            // 2、如果还没到时间，则跳过
            var nextDate = bank.nextDepositDate
            if nextDate > now {
                print("存钱罐:\(bank)的定期存款时间大于当前时间，跳出定期存款逻辑。")
                continue
            }
            
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
