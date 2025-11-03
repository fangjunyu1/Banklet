//
//  ManagingView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI
import SwiftData

struct ManagingView: View {
//    @AppStorage("pageSteps") var pageSteps: Int = 1
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Environment(AppStorageManager.self) var appStorage
    @Query var piggyBank: [PiggyBank]
    @State private var itemToDelete: PiggyBank? // 新增状态变量，用于存储要删除的存钱罐
    //    @State private var currentIndex = 0
    @State private var deletePrompt = false
    //    @State private var refreshID = UUID() // 新增刷新标识符
    
    let generator = UISelectionFeedbackGenerator()
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.95
                let height = geometry.size.height * 0.85
                
                ZStack {
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    VStack {
                        
                        ScrollView(.horizontal,showsIndicators: false) {
                            // 创建按钮
                            HStack {
                                Button(action: {
                                    // 跳转到创建视图
                                    // 删除此处代码
                                }, label: {
                                    VStack {
                                        Image(systemName: "plus")
                                            .font(.title)
                                    }
                                    .padding(10)
                                    .frame(width: 140, height: 200)
                                    .background(colorScheme == .light ? .white : Color(hex:"2C2B2D"))
                                    .cornerRadius(10)
                                    .shadow(radius: 0.5)
                                })
                                // 存钱罐列表
                                ForEach(Array(piggyBank.enumerated()), id: \.offset) { index,item in
                                    VStack {
                                        // 图标和更多
                                        HStack {
                                            // 图标
                                            Button(action: {
                                                // 设置主存钱罐
                                                guard !piggyBank[index].isPrimary else {
                                                    return
                                                }
                                                if appStorage.isVibration {
                                                    // 发生振动
                                                    generator.prepare()
                                                    generator.selectionChanged()
                                                }
                                                // Step 1: 查询所有存钱罐
                                                let fetchRequest = FetchDescriptor<PiggyBank>()
                                                let existingPiggyBanks = try? modelContext.fetch(fetchRequest)
                                                
                                                // Step 2: 将所有存钱罐的 isPrimary 设置为 false
                                                existingPiggyBanks?.forEach { bank in
                                                    bank.isPrimary = false
                                                }
                                                // Step 3: 当点击的存钱罐设置为true
                                                withAnimation {
                                                    piggyBank[index].isPrimary = true
                                                }
                                            }, label: {
                                                Circle().frame(width: 50)
                                                    .foregroundColor(piggyBank[index].isPrimary ? .white : AppColor.bankList[index % AppColor.bankList.count])
                                                    .opacity(0.1)
                                                    .overlay {
                                                        Image(systemName: piggyBank[index].icon)
                                                            .foregroundColor(piggyBank[index].isPrimary ? .white: AppColor.bankList[index % AppColor.bankList.count])
                                                    }
                                            })
                                            Spacer()
                                            // 更多
                                            VStack {
                                                Spacer().frame(height: 10)
                                                // 删除菜单
                                                Menu {
                                                    Button(action: {
                                                        itemToDelete = piggyBank[index]
                                                        deletePrompt.toggle()
                                                    }, label: {
                                                        Text("Delete")
                                                        Spacer()
                                                        Image(systemName: "trash")
                                                    })
                                                } label: {
                                                    Image(systemName:"ellipsis")
                                                        .foregroundColor(piggyBank[index].isPrimary ? .white :.gray)
                                                        .frame(height:20)
                                                }
                                                Spacer()
                                            }
                                        }
                                        .frame(height: 50)
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            // 存钱罐名称
                                            Text(NSLocalizedString(piggyBank[index].name, comment: "存钱罐名称"))
                                                .font(.caption2)
                                                .foregroundColor(piggyBank[index].isPrimary ? .white :.gray)
                                            // 存钱罐占比
                                            Text("\((piggyBank[index].amount / piggyBank[index].targetAmount * 100).formattedWithTwoDecimalPlaces()) %")
                                                .multilineTextAlignment(.leading)
                                                .fontWeight(.bold)
                                                .foregroundColor(piggyBank[index].isPrimary ? .white : colorScheme == .light ? .black : .white)
                                            Rectangle().frame(width: 110, height: 5)
                                                .cornerRadius(10)
                                                .foregroundColor(piggyBank[index].isPrimary ? .white :.gray)
                                                .opacity(0.3)
                                                .overlay {
                                                    HStack {
                                                        Rectangle().frame(width: 110 * (piggyBank[index].amount / piggyBank[index].targetAmount), height: 5)
                                                            .cornerRadius(10)
                                                            .foregroundColor(piggyBank[index].isPrimary ? .white : AppColor.bankList[index % AppColor.bankList.count])
                                                        Spacer()
                                                    }
                                                }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    .padding(10)
                                    .frame(width: 140, height: 200)
                                    .background(piggyBank[index].isPrimary ? AppColor.bankList[index % AppColor.bankList.count]: colorScheme == .light ? .white : Color(hex:"2C2B2D"))
                                    .opacity(colorScheme == .light ? 1 : 0.8)
                                    .cornerRadius(10)
                                    .shadow(radius: 0.5)
                                    // 删除提示框
                                    // 在删除提示框中删除存钱罐
                                    .alert("Delete prompt", isPresented: $deletePrompt) {
                                        Button("Confirm", role: .destructive) {
                                            if let itemToDelete = itemToDelete {
                                                // 检查是否要删除的是主存钱罐
                                                if itemToDelete.isPrimary {
                                                    // 查找其他的存钱罐并设置为主存钱罐
                                                    DispatchQueue.main.async {
                                                        do {
                                                            // 获取所有存钱罐
                                                            let piggyBanks = try modelContext.fetch(FetchDescriptor<PiggyBank>())
                                                            
                                                            // 过滤掉当前要删除的存钱罐
                                                            let remainingBanks = piggyBanks.filter { $0 != itemToDelete }
                                                            
                                                            // 如果还有其他存钱罐，设置第一个为主存钱罐
                                                            if let newPrimary = remainingBanks.last {
                                                                newPrimary.isPrimary = true
                                                                print("已将另一个存钱罐设置为主存钱罐：\(newPrimary.name ?? "Unknown")")
                                                            }
                                                        } catch {
                                                            print("获取存钱罐列表失败: \(error)")
                                                        }
                                                    }
                                                }
                                                DispatchQueue.main.async {
                                                    modelContext.delete(itemToDelete) // 删除数据
                                                }
                                                do {
                                                    try modelContext.save() // 提交上下文中的所有更改
                                                } catch {
                                                    print("保存失败: \(error)")
                                                }
                                            }
                                        }
                                    } message: {
                                        Text("Are you sure you want to delete this piggy bank?")
                                    }
                                }
                            }
                            
                        }
                        .padding(.horizontal,5)
                    }
                    .navigationTitle("Manage")
                    .navigationBarTitleDisplayMode(.inline)
                    .frame(width: width)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: {
                                dismiss()
                            }, label: {
                                Text("Completed")
                                    .fontWeight(.bold)
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            })
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ManagingView()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
    //        .environment(\.locale, .init(identifier: "de"))
}
