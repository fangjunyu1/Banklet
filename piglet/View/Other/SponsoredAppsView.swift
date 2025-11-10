//
//  SponsoredAppsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/20.
//

import SwiftUI

struct SponsoredAppsView: View {
    
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
//    @AppStorage("20240523") var isInAppPurchase = false
    @EnvironmentObject var iapManager: IAPManager
    @State private var endOfWait = false    // 为true时，显示结束等待按钮
    
    let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                VStack {
                        Group {
                            Image("supportWe")
                                .resizable()
                                .scaledToFit()
                                .frame(width: width * 0.75)
                                .opacity(colorScheme == .light ? 1 : 0.8)
                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                            Text("Image by freepik")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        Spacer().frame(height: 16)                   // 储蓄每一个梦想文字部分
                    Group {
                        // 储蓄每一个梦想
                        Text("Save every dream")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer().frame(height: 10)
                        // 如果您对我们的应用满意...
                        Text("  ") + Text("If you are satisfied with our app, we hope you can sponsor us through in-app purchases to help us develop more and better apps.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .lineLimit(4)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 20)
                    VStack {
                        // 赞助应用 + 非消耗性... + 图标
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Sponsored Apps")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                Text("Non-consumable items")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(colorScheme == .light ? Color(hex:"EE2B00") : .white)
                        }
                        // 水平分割线
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: width * 0.9,height:0.5)
                        // 存钱罐图标和介绍
                        HStack {
                            // 存钱罐图标
                            Image(colorScheme == .light ? "iconWhite" : "iconWhiteDark")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                            Text("Get more pictures and animations.")
                                .font(.footnote)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                            Spacer()
                        }
                    }
                    .padding(.horizontal,18)
                    .padding(.vertical,12)
                    .background(colorScheme == .light ? .white : Color(hex:"2C2B2D"))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    // Apple汇率
                    Group {
                        Text("  ") +  Text("Apple will adjust the specific amount of the sponsorship amount based on the exchange rate/tax of the national currency.")
                            .font(.footnote)
                            .foregroundStyle(.gray)
                    }
                    .padding(.vertical, 8)
                    
                    // 内购按钮
                    Group {
                        if appStorage.isInAppPurchase {
                            Rectangle()
                                .foregroundColor(colorScheme == .light ? Color(hex:"EE2B00") : Color(hex:"1c1c1c"))
                                .frame(width: 180,height: 60)
                                .cornerRadius(10)
                                .padding(.vertical,10)
                                .overlay {
                                    Button(action: {
                                        // 内购完成，不执行任何代码
                                    }, label: {
                                        Text("In-app purchase completed")
                                            .fontWeight(.bold)
                                            .frame(width: 180,height: 60)
                                            .foregroundColor(.white)
                                            .background((colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D")))
                                            .cornerRadius(10)
                                    })
                                    .offset(y: -10)
                                }
                            
                        } else {
                            Button(action: {
                                print("当前内购状态:\(appStorage.isInAppPurchase)")
                                if appStorage.isVibration {
                                    // 发生振动
                                    generator.prepare()
                                    generator.selectionChanged()
                                }
                                if !iapManager.products.isEmpty {
                                    iapManager.loadPurchased = true // 显示加载动画
                                    // 将商品分配给一个变量
                                    let productToPurchase = iapManager.products[0]
                                    // 分开调用购买操作
                                    iapManager.purchaseProduct(productToPurchase)
                                    // 当等待时间超过20秒时，显示结束按钮
                                    Task {
                                        try? await Task.sleep(nanoseconds: 20_000_000_000) // 延迟 20 秒
                                        endOfWait = true
                                    }
                                } else {
                                    print("products为空")
                                    Task {
                                        await iapManager.loadProduct()   // 加载产品信息
                                    }
                                }
                            }, label: {
                                // 底部深橘色
                                Rectangle()
                                    .foregroundColor(colorScheme == .light ? Color(hex:"D33E00") : Color(hex:"1c1c1c"))
                                    .frame(width: 220,height: 60)
                                    .cornerRadius(10)
                                    .overlay {
                                        // 上面浅橘色
                                        Rectangle()
                                            .cornerRadius(10)
                                            .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))                   .offset(y:-10)
                                            .overlay {
                                                // 内购文字
                                                VStack {
                                                    Text("Sponsored Apps")
                                                        .fontWeight(.bold)
                                                    if !iapManager.products.isEmpty {
                                                        Text("\(iapManager.products.first?.displayPrice ?? "N/A")")
                                                            .font(.footnote)
                                                            .lineLimit(1) // 限制文本为一行
                                                            .minimumScaleFactor(0.5) // 最小缩放比例
                                                    } else {
                                                        Text("$ --")
                                                            .font(.footnote)
                                                            .lineLimit(1) // 限制文本为一行
                                                            .minimumScaleFactor(0.5) // 最小缩放比例
                                                    }
                                                }
                                                .offset(y: -10)
                                                .foregroundColor(.white)
                                            }
                                    }
                            })
                            .padding(.vertical,10)
                        }
                        // 恢复内购
                        Button(action: {
                            if !iapManager.products.isEmpty {
                                iapManager.loadPurchased = true // 显示加载动画
                                // 将商品分配给一个变量
                                let productToPurchase = iapManager.products[0]
                                // 分开调用购买操作
                                iapManager.purchaseProduct(productToPurchase)
                                // 当等待时间超过20秒时，显示结束按钮
                                Task {
                                    try? await Task.sleep(nanoseconds: 20_000_000_000) // 延迟 20 秒
                                    endOfWait = true
                                }
                            } else {
                                print("products为空")
                                Task {
                                    await iapManager.loadProduct()   // 加载产品信息
                                }
                            }
                        }, label: {
                            Text("Restore Purchases")
                                .font(.footnote)
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : .gray)
                        })
                    }
                    Spacer()
                }
                .frame(width: width)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                .navigationTitle("Sponsored Apps")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement:.topBarLeading) {
                        Button(action: {
                            dismiss()
                        }, label: {
                            Text("Completed")
                                .fontWeight(.bold)
                                .foregroundColor(colorScheme == .light ? .black : .white)
                        })
                    }
                }
                
            }
            .overlay {
                if iapManager.loadPurchased == true {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        VStack {
                            // 加载条
                            ProgressView("loading...")
                            // 加载条修饰符
                                .progressViewStyle(CircularProgressViewStyle())
                                .padding()
                                .background(colorScheme == .dark ? Color(hex: "A8AFB3") : Color.white)
                                .cornerRadius(10)
                                .overlay {
                                    // 当等待时间超过10秒时显示结束
                                    if endOfWait == true {
                                        Button(action: {
                                            iapManager.loadPurchased = false
                                        }, label: {
                                            Text("End of the wait")
                                                .foregroundStyle(.red)
                                                .frame(width: 100,height: 30)
                                                .background(.white)
                                                .cornerRadius(10)
                                        })
                                        .offset(y:60)
                                    }
                                }
                            
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SponsoredAppsView()
        .environmentObject(IAPManager.shared)
        .environment(\.locale, .init(identifier: "de"))
        .environment(AppStorageManager.shared)
        .modelContainer(PiggyBank.preview)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(SoundManager.shared)
}
