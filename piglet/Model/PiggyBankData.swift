//
//  PiggyBankData.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/2.
//
//  临时的PiggyBank变量

import SwiftUI

struct PiggyBankData {
    var dataVersion: Int = 2    // 新字段：数据版本，默认为 2
    var isPrimary: Bool = false // 旧字段：暂时保留，后续不再用于列表管理
    var isPinned: Bool = false  // 新字段：是否置顶
    var name: String = ""  // 存钱罐名称
    var icon:String = "piggybank"   // 图标名称
    var optionalTargetAmount: Double?  // 目标金额
    var creationDate: Date = Date()    // 创建日期
    var expirationDate: Date = Date()     // 截止日期
    var isExpirationDateEnabled: Bool = false   // 是否设置截止日期
    var isFixedDeposit:Bool = false   // 是否设置定额存款
    var fixedDepositType: String = FixedDepositEnum.Daily.rawValue  //  定期存款类型
    var fixedDepositAmount: Double?   // 定期金额
    var nextDepositDate: Date = Date()  // 最近一次定期存款日期
    var fixedDepositWeekday: Int = 1    // 定期存款-周几（1表示日，1表示一，范围1-7）
    var fixedDepositDay: Int = 1    // 定期存款-每月（1-31）
    var fixedDepositTime: Date = Date() // 定期存款-每天时分、每年月日
    var completionDate: Date = Date()   // 完成日期，当存起罐满的时候，更新完成时间
    var sortOrder: Int = 0  // 排序字段
    var customImageFilename: String? = nil  // 自定义愿望图片的文件名
}

extension PiggyBankData {

    // 获取贴纸图片
    var getImg: String {
        IconList.getTextureName(name: icon)
    }
    
    /// 排序用的置顶权重，置顶为 1，未置顶为 0
    var pinnedSortOrder: Int {
        isPinned ? 1 : 0
    }
}
