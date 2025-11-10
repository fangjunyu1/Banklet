//
//  PremiumView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/10.
//
// 高级会员视图

import SwiftUI
import StoreKit

struct PremiumView: View {
    @EnvironmentObject var iapManager: IAPManager
    @State private var loadPurchased = false    // 加载画布
    @State private var selectedProduct: Product?
    var body: some View {
        VStack {
            // 显示列表
            ScrollView {
                VStack(spacing: 20) {
                    VStack {
                        // 会员 动画
                        LottieView(filename: "vip", isPlaying: true, playCount: 0, isReversed: false)
                            .scaledToFit()
                            .scaleEffect(1.3)
                            .frame(maxHeight: 130)
                            .frame(maxWidth: 500)
                        VStack(spacing: 15) {
                            // 储蓄每一个梦想
                            Text("Saving every dream")
                                .modifier(TitleModifier())
                            Text("Give your piggy bank a fresh new look with more customization options, smoother animations, and unique themes.")
                                .modifier(FootNoteModifier())
                        }
                    }
                    // 选择方案、包含内容、购买提示的视图
                    PremiumComponentsView(selectedProduct:$selectedProduct)
                }
            }
            
            // 只有加载产品，才会显示购买方案。
            if !iapManager.products.isEmpty {
                // 购买会员
                BuyPremiumView(selectedProduct:$selectedProduct)
            }
        }
        .navigationTitle("Premium Member")
        .modifier(BackgroundModifier())
        .scrollIndicators(.hidden)
        .onAppear(perform: CheckPurchaseStatus)
    }
    
    @MainActor
    private func CheckPurchaseStatus() {
        Task {
            // 如果没有产品信息，则重新获取
            if iapManager.products.isEmpty {
                await iapManager.loadProduct()
            }
        }
    }
}

// 选择方案、包含内容、购买提示的视图
private struct PremiumComponentsView: View {
    @Binding var selectedProduct: Product?
    @EnvironmentObject var iapManager: IAPManager
    var body: some View {
        VStack(spacing: 20) {
            // 只有加载产品，才会显示选择方案。
            // 选择方案
            VStack {
                HStack {
                    Footnote(text: "Choose a solution")
                    Spacer()
                }
                // 选择方案-列表
                VStack(spacing: 10) {
                    ForEach(Array(iapManager.IAPProductList.enumerated()), id:\.1.id) { index, item in
                        if let products = iapManager.products.first(where: { $0.id == item.id }) {
                            HStack(spacing: 8) {
                                if selectedProduct == products {
                                    Image(systemName: "checkmark.circle.fill")
                                        .imageScale(.large)
                                        .foregroundColor(AppColor.appColor)
                                } else {
                                    Image(systemName: "circle")
                                        .imageScale(.large)
                                        .foregroundColor(AppColor.gray)
                                }
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(LocalizedStringKey(item.name))
                                        .font(.subheadline)
                                        .foregroundColor(AppColor.appGrayColor)
                                    HStack(spacing: 0) {
                                        Caption2(text: products.displayPrice)
                                        if let priceSuffix = item.priceSuffix {
                                            Caption2(text:"/")
                                            Caption2(text: priceSuffix)
                                        }
                                    }
                                }
                                Spacer()
                                if item.name == "Lifetime" {
                                    Text("Best choice")
                                        .font(.footnote)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal,14)
                                        .background(AppColor.appColor)
                                        .cornerRadius(5)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                // 如果重复点击内购商品，则清空内购商品
                                if selectedProduct == products {
                                    selectedProduct = nil
                                } else {
                                    selectedProduct = products
                                }
                            }
                            // 分割线
                            if index < iapManager.IAPProductList.count - 1 {
                                Divider().padding(.leading, 40)
                            }
                        }
                    }
                }
                .modifier(VStackModifier())
            }
            
            // 包含内容
            VStack {
                HStack {
                    Footnote(text: "Contents")
                    Spacer()
                }
                // 包含内容-列表
                VStack {
                    ForEach(Array(PreminumList.enumerated()), id:\.offset) { index, item in
                        premiumItemView(premium: item)
                        if index != PreminumList.count - 1 {
                            Divider().padding(.leading, 50)
                        }
                    }
                }
                .modifier(VStackModifier())
            }
            
            // 购买提示
            VStack {
                HStack {
                    Footnote(text: "Purchase Tips")
                    Spacer()
                }
                VStack(alignment: .leading, spacing:3) {
                    ForEach(PurchaseNoticeList, id:\.self) { item in
                        Text(LocalizedStringKey(item))
                            .font(.caption2)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(AppColor.appGrayColor)
                    }
                }
                .modifier(VStackModifier())
            }
        }
    }
}


// 购买会员按钮视图
private struct BuyPremiumView: View {
    @EnvironmentObject var iapManager: IAPManager
    @Binding var selectedProduct: Product?
    var body: some View {
        VStack(spacing: 10) {
            // 购买会员-按钮
            Button(action: {
                HapticManager.shared.selectionChanged()
                if let selectedProduct = selectedProduct {
                    iapManager.purchaseProduct(selectedProduct)
                }
            }, label: {
                VStack {
                    // 会员信息
                    HStack {
                        Text("Purchase Membership")
                        if let selectedProduct = selectedProduct,let product = iapManager.IAPProductList.first(where: { $0.id == selectedProduct.id }) {
                            Text("(\(product.name))")
                        }
                    }
                    // 价格
                    if let selectedProduct = selectedProduct,let product = iapManager.IAPProductList.first(where: { $0.id == selectedProduct.id }) {
                        HStack(spacing: 0) {
                            Text(selectedProduct.displayPrice)
                            if let priceSuffix = product.priceSuffix {
                                Text("/")
                                Text(LocalizedStringKey(priceSuffix))
                            }
                        }
                        .font(.caption2)
                        .foregroundColor(.white)
                    }
                }
                .modifier(ButtonModifier2())
            })
            // 恢复购买-按钮
            Button(action: {
                HapticManager.shared.selectionChanged()
                IAPManager.shared.restoredPurchasesStatus()
            },label: {
                Footnote(text:"Restore Purchases")
            })
        }
    }
}

private struct premiumItemView: View {
    var premium: PreminumModel
    var body: some View {
        // 单行
        HStack(spacing: 10) {
            // 图标
            VStack {
                ZStack {
                    Rectangle()
                        .frame(width: 30, height: 30)
                        .cornerRadius(10)
                        .foregroundColor(premium.color)
                    Group {
                        if premium.imgModel == .img {
                            Image(premium.imgName)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                        } else {
                            Image(systemName: premium.imgName)
                                .resizable()
                                .scaledToFit()
                        }
                    }
                    .frame(width: 18)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.white)
                }
                Spacer()
            }
            // 标题和描述
            VStack(alignment: .leading, spacing: 3) {
                Text(LocalizedStringKey(premium.text))
                    .font(.caption)
                    .foregroundColor(AppColor.appGrayColor)
                Caption2(text: premium.info)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
    }
}

private struct VStackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .background(.white)
            .cornerRadius(10)
    }
}

#Preview {
    NavigationStack{
        PremiumView()
    }
    .environment(IAPManager.shared)
}
