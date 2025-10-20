//
//  InitializationCompletedView.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/31.
//

import SwiftUI
import SwiftData

struct CompletedView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @Environment(AppStorageManager.self) var appStorage
    
    let generator = UISelectionFeedbackGenerator()

    @Binding var pageSteps: Int
    @Binding var piggyBankData: PiggyBankData // 绑定 ContentView 中的 PiggyBankData
    
    func save() {
        // Step 1: 查询所有存钱罐
        let fetchRequest = FetchDescriptor<PiggyBank>()
        let existingPiggyBanks = try? modelContext.fetch(fetchRequest)
        
        // Step 2: 将所有存钱罐的 isPrimary 设置为 false
        existingPiggyBanks?.forEach { bank in
            bank.isPrimary = false
        }
        // Step 3: 创建新的存钱罐并设置 isPrimary 为 true
        let piggyBank = PiggyBank(name: piggyBankData.name == "" ? "Piggy Bank" : piggyBankData.name,
                                  icon: piggyBankData.icon == "" ? "shadow" : piggyBankData.icon,
                                  initialAmount:
                                    piggyBankData.targetAmount == 0 ? 0 :
                                    piggyBankData.initialAmount > piggyBankData.targetAmount ? piggyBankData.targetAmount : piggyBankData.initialAmount,
                                  targetAmount: piggyBankData.targetAmount == 0 ? 100.0 : piggyBankData.targetAmount,
                                  amount:
                                    piggyBankData.targetAmount == 0 ? 0 : piggyBankData.amount > piggyBankData.targetAmount ? piggyBankData.targetAmount : piggyBankData.amount,
                                  creationDate: piggyBankData.creationDate,
                                  expirationDate: piggyBankData.expirationDate,
                                  isExpirationDateEnabled: piggyBankData.isExpirationDateEnabled,
                                  isPrimary: piggyBankData.isPrimary)
        modelContext.insert(piggyBank) // 将对象插入到上下文中
        do {
            try modelContext.save() // 提交上下文中的所有更改
        } catch {
            print("保存失败: \(error)")
        }
    }
    var body: some View {
        
        GeometryReader { geometry in
            // 通过 `geometry` 获取布局信息
            let width = geometry.size.width * 0.85
            let height = geometry.size.height
            VStack {
                Spacer().frame(height: height * 0.05)
                    Image("finish")
                        .resizable()
                        .scaledToFit()
                        .frame(width: width)
                        .opacity(colorScheme == .light ? 1 : 0.8)
                        .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                    Text("Image by freepik")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .offset(y: -16)
                    Spacer().frame(height: height * 0.05)
                // 恭喜你，创建完成首歌存钱罐
                Group {
                    Text("Congratulations, you have created it")
                    Text("Your piggy bank.")
                }
                .font(.largeTitle)
                .fontWeight(.semibold)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.center)
                Spacer().frame(height: height * 0.05)
                Text("A piggy bank is not just a container for coins, it’s a symbol of dreams and discipline.")
                    .multilineTextAlignment(.center)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Spacer()
                // 重新创建按钮
                Button(action: {
                    pageSteps = 3
                }, label: {
                    Text("Re-create")
                        .font(.footnote)
                        .foregroundColor(.gray)
                })
                Spacer().frame(height: height * 0.02)
                // 完成按钮
                Button(action: {
                    save()
                    pageSteps = 0
                    // 重制存钱罐对象
                    piggyBankData = PiggyBankData()
                }, label: {
                    Text("Completed")
                        .frame(width: 320,height: 60)
                        .foregroundColor(Color.white)
                        .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                        .cornerRadius(10)
                })
                Spacer().frame(height: height * 0.05)
            }
            .frame(width: width)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .overlay {
                VStack{
                    LottieView(filename: "Fireworks1",isPlaying: true, playCount: 0, isReversed: false)
                        .frame(height: 300)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 占满整个屏幕
            }
        }
    }
}

#Preview {
    CompletedView(pageSteps: .constant(5),piggyBankData: .constant(PiggyBankData()))
        .environment(\.locale, .init(identifier: "de"))
        .modelContainer(PiggyBank.preview)
                .environment(AppStorageManager.shared)
                .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
                .environmentObject(IAPManager.shared)
                .environmentObject(SoundManager.shared)
}
