//
//  SavingsScheduler.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/11.
//

import Foundation

// 计算下一次存钱周期的方法
struct SavingsScheduler {
    static func calculateNextDate(type:String,
                                  time: Date,
                                  weekday: Int?,
                                  day: Int?) -> Date {
        
        let now = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        // 非每日定期存款的组件
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        components.second = 0 // 秒数归零，保持整洁
        
        print("当前类型为:\(FixedDepositEnum.day.rawValue)")
        switch type {
            // 每天存款
        case FixedDepositEnum.day.rawValue:
            print("组件时间为:\(hour)小时，\(minute)分钟")
            components.hour = hour
            components.minute = minute
        case FixedDepositEnum.week.rawValue:
            print("组件每周:\(weekday ?? 0)")
            components.weekday = weekday
        case FixedDepositEnum.month.rawValue:
            print("组件每月:\(day ?? 0)")
            components.day = day
        case FixedDepositEnum.year.rawValue:
            let month = calendar.component(.month, from: time)
            let day = calendar.component(.day, from: time)
            components.month = month
            components.day = day
            print("组件每年:\(month)月，\(day) 日")
        default:
            print("组件为空，返回当前时间:\(now.formatted())")
            return now
        }
        
        let nextDate = calendar.nextDate(after: now,
            matching: components,
            matchingPolicy: .previousTimePreservingSmallerComponents,
            repeatedTimePolicy: .first,
            direction: .forward)
        print("下一个时间为:\(nextDate?.formatted() ?? "nil")")
        return nextDate ?? now
    }
}
