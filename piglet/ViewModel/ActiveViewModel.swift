//
//  ActiveViewModel.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/18.
//

import SwiftUI
import SwiftData

@Observable
@MainActor
final class ActiveViewModel:ObservableObject {
    var input = ActivityInput()
    var step: ActivityStep = .calculate
    var lifeSavingRows: [AnimationRow] = [] // 人生存钱罐数组
    var isErrorMsg = false
    
    // 人生存钱罐
    private let growthRate: Double = 0.05     // 薪资增长率 (如 0.05 表示 5%)
    private let startingAge: Int = 18    // 起始年龄
    private let retirementAge: Int = 65     // 预期退休年龄
    
    // MARK: - 处理计算界面的点击手势
    func calculateButton(for tab: ActivityTab) {
        print("进入calculateButton")
        // 振动
        HapticManager.shared.selectionChanged()
        // 按钮显示 loading 等待状态
        step = .calculating
        // 计算人生存钱罐
        Task { @MainActor in
            do {
                if tab == .LifeSavingsBank {
                    try lifeSavingsBankCalculate()
                    await runLifeSavingBankAnimation()
                    print("显示人生存钱罐的动画")
                } else if tab == .EmergencyFund {
                    // 计算生活保障金
                    try await emergencyFundCalculate()
                }
                step = .create   // 显示创建界面
            } catch {
                showError()
            }
        }
    }
    
    // 用户点击创建存钱罐
    func createButton(for tab: ActivityTab) {
        Task { @MainActor in
            step = .creating
            try? await Task.sleep(nanoseconds: 2_000_000_000)  // 等2秒
            do {
                if tab == .LifeSavingsBank {
                    try createLifeSavingBank()
                } else if tab == .EmergencyFund {
                    try createEmergencyFund()
                }
            } catch CalculationError.containerCreationFailed {
                print("无法创建 ModelContainer")
            } catch CalculationError.fetchFailed(let e) {
                print("查询失败: \(e)")
            } catch CalculationError.saveFailed(let e) {
                print("保存失败: \(e)")
            } catch {
                print("未知错误:\(error)")
            }
            step = .complete
        }
    }
    
    // 用户点击取消按钮
    func cancelButton(for tab: ActivityTab) {
        Task { @MainActor in
            step = .creating
            print("设置为计算中状态")
            try? await Task.sleep(nanoseconds: 2_000_000_000)  // 等2秒
            print("等待2秒钟")
            if tab == .LifeSavingsBank {
                while !lifeSavingRows.isEmpty {
                    lifeSavingRows.removeLast()
                    try? await Task.sleep(nanoseconds: 300_000_000)  // 等 0.3 秒
                }
            } else if tab == .EmergencyFund {
                
            }
            print("设置为计算状态")
            step = .calculate
        }
    }
    
    // 用户点击完成按钮
    func completeButton() {
        step = .calculate
        input = ActivityInput()
        lifeSavingRows = []
        isErrorMsg = false
    }
    
    // MARK: - 计算 - 人生存钱罐
    private func lifeSavingsBankCalculate() throws {
        // 检查输入的年龄和年薪是否正确，年龄要求大于等于起始年龄，小于等于退休年龄
        guard let age = input.age,
              let annualSalary = input.annualSalary,
              age >= startingAge,
              age <= retirementAge else {
            print("当前年龄无效，无法计算起始薪资！")
            throw CalculationError.invalidInput
        }
        
        
        // 起始年薪 = 当前年薪 / 1+0.05（增长率）的年龄差值
        // 假设1:当前年龄为18岁，年薪为100，100 / pow(1+0.05,0) = 100
        // 年龄为18岁，年薪为100，起始年薪也是100.
        // 假设2:当前年龄为19岁，年薪为100，100 / pow(1+0.05,19-18=1) = 95
        // 年龄为19岁，起始年薪为95，以此类推
        let startingSalary = Double(annualSalary) / pow(1 + growthRate, Double(age - startingAge))
        input.startingSalary = Int(startingSalary)
        print("起始年龄为:\(startingAge),初始薪资为：\(startingSalary)")
        
        // 累计全部收入
        var salary = startingSalary
        var total: Double = 0.0
        for i in startingAge...retirementAge {
            print("第:\(i)岁，起始年薪为:\(salary)")
            total += salary
            salary *= (1 + growthRate)  // 每年增长
        }
        
        // 完成人生存钱罐的金额
        input.lifeSavingsBank = Int(total)
        print("人生存钱罐的金额为:\(Int(total))")
    }
    
    // 显示人生存钱罐动画
    private func runLifeSavingBankAnimation() async {
        lifeSavingRows.removeAll()
        try? await Task.sleep(nanoseconds: 2_000_000_000)  // 等2秒
        
        guard let lifeSavingsBank = input.lifeSavingsBank else {
            return
        }
        // 展示前两个年龄
        let salary = Double(input.startingSalary)   // 起始年薪
        for i in startingAge...startingAge + 1 {
            // 当前年薪 = 起始年薪的1.05的年龄差
            let startSalary = Double(salary) * pow(1 + growthRate, Double(i - startingAge))
            withAnimation { lifeSavingRows.append(AnimationRow.year(age: i, salary: Int(startSalary))) }
            print("第:\(i)岁，起始年薪为:\(input.startingSalary)")
            try? await Task.sleep(nanoseconds: 2_000_000_000)  // 等2秒
        }
        // 插入等待符
        withAnimation { lifeSavingRows.append(.gap) }
        try? await Task.sleep(nanoseconds: 4_000_000_000)  // 等4秒
        // 展示后两个年龄
        for i in retirementAge - 1...retirementAge {
            // 当前年薪 = 起始年薪的1.05的年龄差
            let EndSalary = Double(salary) * pow(1 + growthRate, Double(i - startingAge))
            withAnimation { lifeSavingRows.append(AnimationRow.year(age: i, salary: Int(EndSalary))) }
            print("第:\(i)岁，起始年薪为:\(input.startingSalary)")
            try? await Task.sleep(nanoseconds: 2_000_000_000)  // 等2秒
        }
        // 插入人生存钱罐
        withAnimation { lifeSavingRows.append(.total(amount: lifeSavingsBank)) }
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)  // 等1秒
    }
    
    // MARK: - 计算 - 生活保障金
    private func emergencyFundCalculate() async throws {
        // 检查输入的生活开销是否正确，不能等于0 或者大于 1000000
        guard let livingExpenses = input.livingExpenses,
              let month = input.guaranteeMonth,
              livingExpenses > 0,
              livingExpenses < 1000000 else {
            print("当前年龄无效，无法计算起始薪资！")
            throw CalculationError.invalidInput
        }
        
        input.emergencyFund = month * livingExpenses
        print("生活保障金的金额为:\(input.emergencyFund ?? 0)")
        try? await Task.sleep(nanoseconds: 2_000_000_000)  // 等2秒
    }
    
    // 显示错误视图
    private func showError() {
        Task { @MainActor in
            print("等待两秒")
            try await Task.sleep(nanoseconds: 2_000_000_000) // 暂停 2 秒
            withAnimation { self.isErrorMsg = true }
            print("显示错误提示")
            step = .calculate
            print("步骤改回计算界面")
            try await Task.sleep(nanoseconds: 2_000_000_000) // 暂停 2 秒
            withAnimation { self.isErrorMsg = false }
            print("隐藏错误提示")
        }
    }
    
    // 创建人生存钱罐
    private func createLifeSavingBank() throws {
        // Step 1: 获取上下文
        let container: ModelContainer
        do {
            container = try ModelContainer(for: PiggyBank.self)
        } catch {
            throw CalculationError.containerCreationFailed
        }
        let context = container.mainContext
        
        // Step 2: 查询所有存钱罐
        let fetchRequest = FetchDescriptor<PiggyBank>()
        let existingPiggyBanks: [PiggyBank]
        do {
            existingPiggyBanks = try context.fetch(fetchRequest)
        } catch {
            throw CalculationError.fetchFailed(error)
        }
        
        // Step 3: 将所有存钱罐的 isPrimary 设置为 false
        existingPiggyBanks.forEach { bank in
            bank.isPrimary = false
        }
        
        // Step 4: 创建新的人生存钱罐
        let piggyBank = PiggyBank(name: "Life savings jar",
                                  icon: "person.fill",
                                  initialAmount:
                                    0,
                                  targetAmount: Double(input.lifeSavingsBank ?? 0),
                                  amount:
                                    0,
                                  creationDate: Date(),
                                  expirationDate: Date(),
                                  isExpirationDateEnabled: false,
                                  isPrimary: true)
        print("创建人生存钱罐")
        
        context.insert(piggyBank) // 将对象插入到上下文中
        
        // Step 5: 保存上下文
        do {
            try context.save() // 提交上下文中的所有更改
        } catch {
            throw CalculationError.saveFailed(error)
        }
        
        print("保存人生存钱罐")
    }
    
    // 创建生活保障金
    private func createEmergencyFund() throws {
        // Step 1: 获取上下文
        let container: ModelContainer
        do {
            container = try ModelContainer(for: PiggyBank.self)
        } catch {
            throw CalculationError.containerCreationFailed
        }
        let context = container.mainContext
        
        // Step 2: 查询所有存钱罐
        let fetchRequest = FetchDescriptor<PiggyBank>()
        let existingPiggyBanks: [PiggyBank]
        do {
            existingPiggyBanks = try context.fetch(fetchRequest)
        } catch {
            throw CalculationError.fetchFailed(error)
        }
        
        // Step 3: 将所有存钱罐的 isPrimary 设置为 false
        existingPiggyBanks.forEach { bank in
            bank.isPrimary = false
        }
        
        // Step 4: 创建新的生活保障金
        let piggyBank = PiggyBank(name: "Emergency Fund",
                                  icon: "heart.fill",
                                  initialAmount:
                                    0,
                                  targetAmount: Double(input.emergencyFund ?? 0),
                                  amount:
                                    0,
                                  creationDate: Date(),
                                  expirationDate: Date(),
                                  isExpirationDateEnabled: false,
                                  isPrimary: true)
        print("创建生活保障金")
        
        context.insert(piggyBank) // 将对象插入到上下文中
        
        // Step 5: 保存上下文
        do {
            try context.save() // 提交上下文中的所有更改
        } catch {
            throw CalculationError.saveFailed(error)
        }
        
        print("保存生活保障金")
    }
    enum ActivityStep {
        case calculate  // 输入年龄、年薪
        case calculating    // 计算中
        case create // 创建视图
        case creating   // 创建中
        case complete   //完成视图
    }
    
    enum CalculationError: Error {
        case invalidInput
        case fetchFailed(Error)
        case saveFailed(Error)
        case containerCreationFailed
    }
    
    enum AnimationRow: Hashable, Identifiable {
        var id: String {
            switch self {
            case .year(let age, _): "year-\(age)"
            case .gap: "gap"
            case .total: "total"
            }
        }
        case year(age: Int, salary: Int)
        case gap
        case total(amount: Int)
    }
}

// 管理活动输入内容
struct ActivityInput {
    // 人生存钱罐
    var age: Int? = nil // 年龄
    var annualSalary: Int? = nil    // 年薪
    var startingSalary: Int = 1  // 起始年薪
    var lifeSavingsBank: Int? = nil // 人生存钱罐
    // 生活保障金
    var livingExpenses: Int? = nil  // 基本生活开销
    var guaranteeMonth: Int? = 6    // 保障月份
    var emergencyFund: Int? = nil   // 生活保障金
}
