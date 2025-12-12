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
        let enumType = FixedDepositEnum(rawValue: draft.fixedDepositType) ?? .day
        
        // 用户的最近存取时间可能是很久之前的时间,提取当前用户选择的 时-分 组件
        var userComponents = calendar.dateComponents([.hour, .minute], from: draft.fixedDepositTime)
        // 提取今天的 年-月-日 组件
        let nowComponents = calendar.dateComponents([.year, .month, .day], from: now)
        // 今天 年-月-日 + 用户选择的时-分，组成最新的日期组件
        userComponents.year = nowComponents.year
        userComponents.month = nowComponents.month
        userComponents.day = nowComponents.day
        userComponents.calendar = Calendar.current
        
        print("用户选择的日期组件:\(userComponents)")
        var nowDayTime: Date
        // 今天的日期和时间，如果用户选择每日存取，那么对应的是今天的存取时间
        if let nowDate = userComponents.date {
            print("转换成功:\(nowDate)") // 转换成功后的具体日期
            nowDayTime = nowDate
        } else {
            nowDayTime = Date()
            print("转换失败")
        }
        
        print("用户选择的时间组件：\(userComponents)")
        print("nowDayTime:\(nowDayTime.formatted())")
        // 判断用户的存取类型
        switch enumType {
        case .day:
            // 如果今天的存取时间大于现在的时间，返回今天的存取时间
            if nowDayTime > now {
                print("选择的时间大于现在的时候，返回选择的时间")
                return nowDayTime
            } else {
                print("选择的时间小于现在的时间，返回下一个时间")
                // 否则，今天的存取时间过时，计算下一次存取时间。
                return calculateNextDate(type: draft.fixedDepositType, lastDate: nowDayTime, weekday: draft.fixedDepositWeekday, day: draft.fixedDepositDay)
            }
        case .week:
            // 如果今天对应的星期，检查是否是否大于9点。
            userComponents.hour = 9
            userComponents.minute = 0
            // 生成今天的日期时间
            let nowWeekTime: Date = userComponents.date ?? Date()
            // 提取今天的星期
            let tmpWeek = calendar.component(.weekday, from: nowWeekTime)
            // 如果今天的星期和用户选择的星期一样，则检查时间。
            if tmpWeek + 1 == draft.fixedDepositWeekday {
                // 判断今天的存取时间是否大于现在的时间
                if nowWeekTime > now {
                    return nowWeekTime
                } else {
                    // 否则计算下一个周期
                    return calculateNextDate(type: draft.fixedDepositType, lastDate: nowWeekTime, weekday: draft.fixedDepositWeekday, day: draft.fixedDepositDay)
                }
            } else {
                // 否则计算下一个周期
                return calculateNextDate(type: draft.fixedDepositType, lastDate: nowWeekTime, weekday: draft.fixedDepositWeekday, day: draft.fixedDepositDay)
            }
        case .month:
            // 如果今天对应的日期，检查是否是否大于9点。
            userComponents.hour = 9
            userComponents.minute = 0
            // 生成今天的日期时间
            let nowMonthTime: Date = userComponents.date ?? Date()
            // 提取今天的几号
            let tmpMonth = calendar.component(.day, from: nowMonthTime)
            // 如果今天的几号和用户选择的几号一样，则检查时间。
            if tmpMonth == draft.fixedDepositDay {
                // 判断今天的存取时间是否大于现在的时间
                if nowMonthTime > now {
                    return nowMonthTime
                } else {
                    // 否则计算下一个周期
                    return calculateNextDate(type: draft.fixedDepositType, lastDate: nowMonthTime, weekday: draft.fixedDepositWeekday, day: draft.fixedDepositDay)
                }
            } else {
                // 否则计算下一个周期
                return calculateNextDate(type: draft.fixedDepositType, lastDate: nowMonthTime, weekday: draft.fixedDepositWeekday, day: draft.fixedDepositDay)
            }
        case .year:
            userComponents = calendar.dateComponents([.year, .month, .day], from: draft.fixedDepositTime)
            // 如果今天对应的日期，检查是否是否大于9点。
            userComponents.calendar = Calendar.current
            userComponents.hour = 9
            userComponents.minute = 0
            // 生成今天的日期时间
            var nowYearTime: Date
            if let nowYear = userComponents.date {
                print("转换成功:\(nowYear)") // 转换成功后的具体日期
                nowYearTime = nowYear
            } else {
                nowYearTime = Date()
                print("转换失败")
            }
            // 如果今天的存取时间大于现在的时间，返回今天的存取时间
            if nowYearTime > now {
                print("选择时间:\(nowYearTime.formatted())")
                print("现在选择的时间大于当前时间，返回选择时间")
                return nowYearTime
            } else {
                print("计算下一个月日")
                // 否则，今天的存取时间过时，计算下一次存取时间。
                return calculateNextDate(type: draft.fixedDepositType, lastDate: nowYearTime, weekday: draft.fixedDepositWeekday, day: draft.fixedDepositDay)
            }
        }
    }
    
    // 计算下一次定期存款时间
    static func calculateNextDate(type: String,
                                  lastDate: Date,
                                  weekday: Int?,
                                  day: Int?) -> Date {
        
        let calendar = Calendar.current
        let enumType = FixedDepositEnum(rawValue: type) ?? .day
        print("存款类型:\(enumType.rawValue)")
        // 非每日定期存款的组件
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        components.second = 0
        
        switch enumType {
        case .day:
            print("当日存款，更新为选中的时间")
            components.hour = calendar.component(.hour, from: lastDate)
            components.minute = calendar.component(.minute, from: lastDate)
            print("当前存钱罐组件时间为:\(components)")
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
