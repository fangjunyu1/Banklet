//
//  SponsoredAppsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/20.
//

import SwiftUI

struct SponsoredAppsView: View {
    @Environment(AppStorageManager.self) var appStorage
    @EnvironmentObject var iapManager: IAPManager
    @State private var endOfWait = false    // 为true时，显示结束等待按钮
    
    var body: some View {
        VStack {
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                if !iapManager.products.isEmpty {
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
                Rectangle()
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
            })
            .padding(.vertical,10)
        }
        .overlay {
            ZStack {
                Color.black.opacity(0.3).ignoresSafeArea()
                VStack {
                    // 加载条
                    ProgressView("loading...")
                    // 加载条修饰符
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .cornerRadius(10)
                        .overlay {
                            // 当等待时间超过10秒时显示结束
                            if endOfWait == true {
                                Button(action: {
                                    
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

#Preview {
    SponsoredAppsView()
        .environmentObject(IAPManager.shared)
        .environment(AppStorageManager.shared)
}
