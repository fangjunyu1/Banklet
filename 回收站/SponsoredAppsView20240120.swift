//
//  SponsoredAppsView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/10.
//

import SwiftUI

struct SponsoredAppsView20240120: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("20240523") var isInAppPurchase = false
    @EnvironmentObject var iapManager: IAPManager
    @State private var endOfWait = false    // 为true时，显示结束等待按钮
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                VStack {
                    // 储蓄每一个梦想。
                    HStack {
                        Image(colorScheme == .light ? "iconWhite" : "iconWhiteDark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                        Spacer().frame(width: 20)
                        VStack(alignment:.leading) {
                            Text("  ") +
                            Text("Save every dream.")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("  ") +
                            Text("This app will not run any ads, ensuring that everyone can enjoy a clean and comfortable application environment.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical,10)
                    
                    // 支持我们
                    HStack {
                        VStack(alignment:.leading) {
                            Text("  ") +
                            Text("Support us.")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("  ") +
                            Text("If you are satisfied with our app, we hope you can sponsor us through in-app purchases to help us develop more and better apps.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        Spacer().frame(width: 20)
                        
                        VStack {
                            Image("supportus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                                .opacity(colorScheme == .light ? 1 : 0.8)
                            Text("Image by freepik")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                        
                    }
                    .padding(.vertical,10)
                    
                    // 内购标题和内购按钮
                    Group {
                        Text("In-app purchase button")
                            .font(.title2)
                            .fontWeight(.bold)
                        // 内购按钮
                        if isInAppPurchase {
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
                                Rectangle()
                                    .foregroundColor(colorScheme == .light ? Color(hex:"EF4B00") : Color(hex:"1c1c1c"))
                                    .frame(width: 180,height: 60)
                                    .cornerRadius(10)
                                    .overlay {
                                    Text("1 USD")
                                        .fontWeight(.bold)
                                        .frame(width: 180,height: 60)
                                        .foregroundColor(.white)
                                        .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                        .cornerRadius(10)
                                        .offset(y:-10)
                                    }
                            })
                            .padding(.vertical,10)
                        }
                        
                    }
                    // 内购提示
                    Group {
                        Text("  ") + Text("Apple will adjust the specific value of the sponsorship amount based on the exchange rate/tax of the national currency.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Text("  ") + Text("In-app purchases are one-time products. Users who have sponsored will automatically resume purchases after clicking \"1 USD\".")
                            .font(.footnote)
                            .foregroundColor(.gray)
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
                        Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
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
    @StateObject var iapManager = IAPManager.shared
    return SponsoredAppsView20240120()
        .environmentObject(iapManager)
}
