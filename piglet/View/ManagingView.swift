//
//  ManagingView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI
import SwiftData

struct ManagingView: View {
    @AppStorage("pageSteps") var pageSteps: Int = 1
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Query var piggyBank: [PiggyBank]
    @State private var currentIndex = 0
    @State private var deletePrompt = false
    @State private var refreshID = UUID() // 新增刷新标识符
    
    @Binding var showManagingView: Bool
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    // 动态调整存钱罐图标大小
    private func getSize(geometry: GeometryProxy) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let distance = abs(screenWidth / 2 - geometry.frame(in: .global).midX)
        let scaleFactor: CGFloat = 1.5 // 控制缩放程度
        let maxSize: CGFloat = 60
        let minSize: CGFloat = 30
        
        let size = max(maxSize - (distance / screenWidth * scaleFactor * maxSize), minSize)
        return size
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentIndex) {
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        Button(action: {
                            // 跳转到创建视图
                            pageSteps = 3
                        }, label: {
                            Image(systemName: "plus.app.fill") // 替换为存钱罐图标
                                .resizable()
                                .scaledToFit()
                                .frame(width: getSize( geometry: geometry), height: getSize(geometry: geometry))
                                .foregroundColor(currentIndex == 0 ? .white : .gray)
                        })
                        .padding(.top, 20)
                        Text("Create")
                            .font(.headline)
                            .foregroundColor(currentIndex == 0 ? .white : .gray)
                            .padding(.top)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .animation(.easeInOut, value: currentIndex)
                }
                .tag(0)
                ForEach(piggyBank.indices, id: \.self) { index in
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            Image(systemName: "\(piggyBank[index].icon)") // 替换为存钱罐图标
                                .resizable()
                                .scaledToFit()
                                .frame(width: getSize(geometry: geometry), height: getSize(geometry: geometry))
                                .foregroundColor(.white)
                            Text(piggyBank[index].name)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.top)
                            // 设为主存钱罐
                            Group {
                                Button(action: {
                                    guard !piggyBank[index].isPrimary else {
                                        return
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
                                    Text(piggyBank[index].isPrimary ? "Main piggy bank" : "Set as primary piggy bank")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                })
                                // 删除该存钱罐
                                Button(action: {
                                    deletePrompt.toggle()
                                }, label: {
                                    Text("Delete this piggy bank")
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                })
                            }
                            .font(.system(size: getSize(geometry: geometry) / 4))
                            .padding(.vertical,10)
                            .padding(.horizontal,20)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .light ? Color(hex: "ec5a29") : .white)
                            .background(colorScheme == .light ? .white : .gray)
                            .cornerRadius(10)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .animation(.easeInOut, value: currentIndex)
                    }
                    .tag(index+1)
                    .alert("Delete prompt",isPresented: $deletePrompt){
                        Button("Confirm", role: .destructive) {
                            currentIndex = min(currentIndex, piggyBank.count - 1)
                            
                            // 检查是否要删除的是主存钱罐
                            if piggyBank[index].isPrimary {
                                // 查找其他的存钱罐并设置为主存钱罐
                                DispatchQueue.main.async {
                                    do {
                                        // 获取所有存钱罐
                                        let piggyBanks = try modelContext.fetch(FetchDescriptor<PiggyBank>())
                                        
                                        // 过滤掉当前要删除的存钱罐
                                        let remainingBanks = piggyBanks.filter { $0 != piggyBank[index] }
                                        
                                        // 如果还有其他存钱罐，设置第一个为主存钱罐
                                        if let newPrimary = remainingBanks.first {
                                            newPrimary.isPrimary = true
                                            print("已将另一个存钱罐设置为主存钱罐：\(newPrimary.name ?? "Unknown")")
                                        }
                                    } catch {
                                        print("获取存钱罐列表失败: \(error)")
                                    }
                                }
                            }
                            DispatchQueue.main.async {
                                modelContext.delete(piggyBank[index]) // 删除数据
                                refreshID = UUID() // 强制刷新视图
                            }
                            do {
                                try modelContext.save() // 提交上下文中的所有更改
                            } catch {
                                print("保存失败: \(error)")
                            }
                        }
                    } message: {
                        Text("Are you sure you want to delete this piggy bank?")
                    }
                }
            }
            .id(refreshID) // 强制刷新
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .frame(height: isLandscape && isCompactScreen ? screenHeight * 0.8 : screenHeight * 0.35)
        }
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    // 隐藏按钮
                    Button(action: {
                        withAnimation(.easeInOut(duration: 1)) {
                            showManagingView.toggle()
                        }
                    }, label: {
                        Image(systemName: "arrowtriangle.down.circle")
                            .font(.largeTitle)
                            .imageScale(.large)
                            .foregroundColor(isCompactScreen ? .white : colorScheme == .light ? Color(hex: "FF4B00") :.white)
                    })
                    Spacer()
                }
                .offset(y:-50)
                Spacer()
            }
        }
        .background(
            Image(colorScheme == .light ? "switchPiggyBank" : "switchPiggyBankBlack")
                .resizable()
                .padding(0)
        )
        .onAppear {
            currentIndex = piggyBank.count
        }
    }
}

#Preview {
    ManagingView(showManagingView: .constant(true))
        .modelContainer(PiggyBank.preview)
        .environment(\.locale, .init(identifier: "de")) 
}
