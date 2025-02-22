//
//  PiggyBankViewModel.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/21.
//

import SwiftUI

@Observable
class PiggyBankViewModel {
    var piggyBanks: [PiggyBank] = []
    
    func loadPiggyBankDataFromAppGroup() {
        print("进入loadPiggyBankDataFromAppGroup 方法")
        print("group.com.fangjunyu.piglet")
        if let appGroupDefaults = UserDefaults(suiteName: "group.com.fangjunyu.piglet") {
            
            let allDefaults = appGroupDefaults.dictionaryRepresentation()
             print("UserDefaults 中的所有内容：\(allDefaults)") // 打印所有内容
            
            let watchData = appGroupDefaults.string(forKey: "Watch")
            print("测试Watch单值存储的数据：\(watchData)")
            
            // 尝试读取数据
            if let piggyBankData = appGroupDefaults.array(forKey: "piggyBanks") as? [[String: Any]] {
                piggyBanks = piggyBankData.compactMap {
                    if let name = $0["name"] as? String,
                       let icon = $0["icon"] as? String,
                       let amount = $0["amount"] as? Double,
                       let targetAmount = $0["targetAmount"] as? Double,
                       let isPrimary = $0["isPrimary"] as? Bool {
                        return PiggyBank(name: name, icon: icon, amount: amount, targetAmount: targetAmount, isPrimary: isPrimary)
                    }
                    return nil
                }
                
                if !piggyBanks.isEmpty {
                    print("Watch 端接收数据成功，接收数据为:\(piggyBanks)")
                } else {
                    print("Watch 端接收到的数据为空或无效。")
                }
            } else {
                print("Watch 端解码失败：未能读取piggyBanks数据")
            }
        } else {
            print("无法读取 App Group UserDefaults")
        }
    }
}
