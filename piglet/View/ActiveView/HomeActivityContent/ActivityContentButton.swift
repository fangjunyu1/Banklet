//
//  ActivityContentButtonView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI

struct ActivityContentButtonView: View {
    @EnvironmentObject var activityVM: ActiveViewModel
    var body: some View {
        Button(action: {
            // 下一步
            calculateButton()
        }, label: {
            Group {
                switch activityVM.step {
                case .calculate:
                    Text("Calculate")
                case .create:
                    Text("Create")
                case .loading:
                    ProgressView("")
                        .tint(.white)
                        .padding(.top,10)
                case .complete:
                    Text("Completed")
                }
            }
            .modifier(ButtonModifier())
        })
        .disabled(activityVM.step == .loading)
    }
    
    private func calculateButton() {
        // 振动
        HapticManager.shared.selectionChanged()
        if activityVM.step == .calculate {
            activityVM.step = .loading
            // 计算人生存钱罐
            if activityVM.tab == .LifeSavingsBank {
                lifeSavingsBankCalculate()
            }
        }
    }
    
    // 计算存钱罐
    private func lifeSavingsBankCalculate() {
        let growthRate: Double = 0.05     // 薪资增长率 (如 0.05 表示 5%)
        let startingAge: Int = 18    // 起始年龄
        var startingSalary: Double = 1    // 起始年薪
        let retirementAge: Int = 65     // 预期退休年龄
        // 检查输入的年龄和年薪是否正确
        if let age = activityVM.input.age,let annualSalary = activityVM.input.annualSalary,age >= startingAge {
            // 起始年薪 = 当前年薪 / 1+0.05（增长率）的年龄差值
            // 假设1:当前年龄为18岁，年薪为100，100 / pow(1+0.05,0) = 100
            // 年龄为18岁，年薪为100，起始年薪也是100.
            // 假设2:当前年龄为19岁，年薪为100，100 / pow(1+0.05,19-18=1) = 95
            // 年龄为19岁，起始年薪为95，以此类推
            startingSalary = Double(annualSalary) / pow(1 + growthRate, Double(age - startingAge))
            print("起始年龄为:\(startingAge),初始薪资为：\(startingSalary)")
            activityVM.step = .calculate
        } else {
            print("当前年龄无效，无法计算起始薪资！")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    activityVM.isErrorMsg = true
                }
                // 将当前状态改回计算状态
                activityVM.step = .calculate
            }
            return
        }
        // 累计全部收入
        var startingEarnings = startingSalary
        var totalEarnings: Double = 0.0
        for i in startingAge...retirementAge {
            print("第:\(i)岁，起始年薪为:\(startingEarnings)")
            totalEarnings += startingEarnings
            startingEarnings *= 1 + growthRate  // 每年增长
        }
        
        // 转换为整数金额
        activityVM.input.lifeSavingsBank = Int(totalEarnings)
        print("人生存钱罐的金额为:\(Int(totalEarnings))")
        activityVM.step = .create
    }
}

