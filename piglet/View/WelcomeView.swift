//
//  WelcomeView.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/29.
//

import SwiftUI
import SwiftData

struct WelcomeView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @Binding var pageSteps: Int
    
    let generator = UISelectionFeedbackGenerator()
    
    // 1.0.1 使用UserDefault存储的内容，下面是迁移代码
    func migrateOldDataIfNeeded() {
        let userDefaults = UserDefaults.standard
        
        // 检查是否已有迁移标记
        if userDefaults.bool(forKey: "hasMigratedToSwiftData") {
            print("数据已迁移，无需重复操作")
            return
        }
        
        // 加载旧数据
//        let currentStep = userDefaults.integer(forKey: "currentStep")
        let pigLetName = userDefaults.string(forKey: "pigLetName") ?? ""
        let pigLettarget = userDefaults.double(forKey: "pigLettarget")
        let pigLetCount = userDefaults.double(forKey: "pigLetCount")
        
        
        // 检查是否有有效数据
        if !pigLetName.isEmpty || pigLettarget > 0 || pigLetCount > 0 {
            // Step 1: 查询所有存钱罐
            let fetchRequest = FetchDescriptor<PiggyBank>()
            let existingPiggyBanks = try? modelContext.fetch(fetchRequest)
            
            // Step 2: 将所有存钱罐的 isPrimary 设置为 false
            existingPiggyBanks?.forEach { bank in
                bank.isPrimary = false
            }
            
            // 将旧数据保存到 SwiftData 模型
            let newPiggyBank = PiggyBank(name: pigLetName, icon: "apple.logo", initialAmount: pigLetCount, targetAmount: pigLettarget, amount: pigLetCount, creationDate: Date(), expirationDate: Date(), isExpirationDateEnabled: false, isPrimary: true)
            modelContext.insert(newPiggyBank)
            do {
                // 保存到数据库
                try modelContext.save()
                print("数据迁移成功！")
                
                // 设置迁移标记
                userDefaults.set(true, forKey: "hasMigratedToSwiftData")
                
                // 清理UserDefaults中的旧值
                clearOldData()
            } catch {
                print("数据迁移失败：\(error.localizedDescription)")
            }
        } else {
            print("没有可迁移的旧数据")
        }
    }
    
    func clearOldData() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "currentStep")
        userDefaults.removeObject(forKey: "pigLetName")
        userDefaults.removeObject(forKey: "pigLettarget")
        userDefaults.removeObject(forKey: "pigLetCount")
        print("旧数据已清理")
    }
    
    var body: some View {
        NavigationStack {
            
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                let height = geometry.size.height
                VStack {
                    // 顶部空白为 height * 0.05
                    Spacer().frame(height: height * 0.05)
                    // 欢迎标题
                    HStack(spacing: 0) {
                        Group {
                            Text("Welcome to use")
                            Text("Banklet")
                      }
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8) 
                    }
                    Spacer().frame(height: height * 0.05)
                        VStack {
                            // 应用图像
                            Image(colorScheme == .light ? "icon" : "iconDark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.3)
                                .cornerRadius(10)
                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                            Spacer().frame(height: height * 0.03)
                            // 随时随地记录您的储蓄信息
                            Text("Record your savings information anytime and anywhere.")
                                .font(.footnote)
                                .foregroundStyle(Color.gray)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .multilineTextAlignment(.center)
                            // 列表显示区域
                            Spacer().frame(height: height * 0.05)
                        }
                   
                    // 详细列表：储蓄愿望、记录生活、汇总账单
                    VStack(alignment: .leading) {
                        // 储蓄愿望
                        HStack {
                            Image("savingswishes")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50,height: 50)
                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                            Spacer().frame(width: 15)
                            VStack(alignment: .leading){
                                Text("Savings Wish")
                                    .fontWeight(.semibold)
                                Spacer().frame(height: 5)
                                Text("Save the desired items, record every savings, and make your wishes come true.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .lineLimit(3)
                                    .minimumScaleFactor(0.8)
                                    .fixedSize(horizontal: false, vertical: true) // 防止文字水平压缩
                            }
                        }
                        
                        Spacer().frame(height: height * 0.03)
                        
                        // 记录生活
                        HStack {
                            Image("recordlife")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50,height: 50)
                                .opacity(colorScheme == .light ? 1 : 0.8)
                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                            Spacer().frame(width: 15)
                            VStack(alignment: .leading){
                                Text("Record Life")
                                    .fontWeight(.semibold)
                                Spacer().frame(height: 5)
                                Text("Develop a habit of saving, record the savings in life, and make yourself feel more at ease.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .lineLimit(3)
                                    .minimumScaleFactor(0.8)
                                    .fixedSize(horizontal: false, vertical: true) // 防止文字水平压缩
                                
                            }
                        }
                        
                        Spacer().frame(height: height * 0.03)
                        // 汇总账单
                        HStack {
                            Image("summarizebills")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50,height: 50)
                                .opacity(colorScheme == .light ? 1 : 0.8)
                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                            Spacer().frame(width: 15)
                            VStack(alignment: .leading){
                                Text("Summarize Bills")
                                    .fontWeight(.semibold)
                                Spacer().frame(height: 5)
                                Text("Query and count every record, and use visual charts to show your wealth.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .lineLimit(3)
                                    .minimumScaleFactor(0.8)
                                    .fixedSize(horizontal: false, vertical: true) // 防止文字水平压缩

                                Spacer().frame(height: 5)
                                
                            }
                        }
                    }
                    Spacer()
                    Button(action: {
                        pageSteps = 2
                    }, label: {
                        Text("Continue")
                            .frame(width: 320,height: 60)
                            .foregroundColor(Color.white)
                            .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                            .cornerRadius(10)
                    })
                    Spacer().frame(height: height * 0.05)
                }
            }
        }
        
    }
}

#Preview {
    WelcomeView(pageSteps: .constant(1))
        .modelContainer(PiggyBank.preview)
        .environment(\.locale, .init(identifier: "de"))   // 设置语言为阿拉伯语
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
