//
//  PremiumView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/10.
//
// 高级会员视图
//
// 1、在应用初始化时，会先获取一遍产品信息
// 异步任务不影响应用，也是为了打开该页面时显示对应的内购产品。
// 2、当视图加载时，调用CheckPurchaseStatus方法，判断产品列表是否有产品
// 如果没有任何产品信息，则会重新尝试获取产品信息列表
//

import SwiftUI
import StoreKit

struct PremiumView: View {
    @Environment(AppStorageManager.self) var appStorage
    @EnvironmentObject var iapManager: IAPManager
    @State private var isLoading = false    // 加载画布
    @State private var selectedProduct: Product?
    @State private var isPurchaseSuccessfulView = false
    @State private var purchaseProductTask: Task<Void, Never>?
    var body: some View {
        VStack {
            // 显示列表
            ScrollView(showsIndicators: false) {
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
                    // 当前方案
                    if appStorage.isValidMember {
                        CurrentPlanView()
                    }
                    // 选择方案、包含内容、购买提示的视图
                    PremiumComponentsView(selectedProduct:$selectedProduct)
                }
                Spacer().frame(height: 20)
            }
            
            // 只有加载产品，才会显示购买方案。
            if !iapManager.products.isEmpty {
                // 购买会员
                BuyPremiumView(selectedProduct:$selectedProduct,loadPurchased: $isLoading,isPurchaseSuccessfulView: $isPurchaseSuccessfulView, purchaseProductTask: $purchaseProductTask)
                    .sheet(isPresented: $isPurchaseSuccessfulView, content: {
                        PurchaseSuccessfulView()
                            .presentationDetents([.height(360)])
                    })
            }
        }
        .navigationTitle("Premium Member")
        .modifier(BackgroundModifier())
        .scrollIndicators(.hidden)
        .onAppear(perform: CheckPurchaseStatus)
        .overlay {
            if isLoading {
                PurchaseLoadingView(isLoading: $isLoading,purchaseProductTask: $purchaseProductTask)
            }
        }
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

// 加载产品-遮罩曾
private struct PurchaseLoadingView: View {
    @Binding var isLoading: Bool
    @Binding var purchaseProductTask: Task<Void, Never>?
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // 振动
                        HapticManager.shared.selectionChanged()
                        isLoading.toggle()
                        purchaseProductTask?.cancel()   // 取消购买任务
                        purchaseProductTask = nil
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.title)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    })
                    Spacer().frame(width: 20)
                }
                Spacer()
            }
            // 加载条
            ProgressView("loading...")
                .padding(20)
                .cornerRadius(10)
                .modifier(WhiteBgModifier())
                .cornerRadius(10)
        }
    }
}

// 当前方案
private struct CurrentPlanView: View {
    @Environment(AppStorageManager.self) var appStorage
    
    let date = Date(timeIntervalSince1970: AppStorageManager.shared.expirationDate)
    let isLifetime = AppStorageManager.shared.isLifetime
    let isSubScription = AppStorageManager.shared.expirationDate > Date().timeIntervalSince1970
    let isValidMember = AppStorageManager.shared.isValidMember
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func formattedDateTest(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            // 只有加载产品，才会显示选择方案。
            // 选择方案
            VStack {
                HStack {
                    Footnote(text: "Current Plan")
                    Spacer()
                }
            }
            // 当前方案
            VStack(spacing: 10) {
                // 永久会员
                if isLifetime {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .imageScale(.large)
                        Text("Premium Member")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        Text("Permanently valid")
                            .font(.footnote)
                    }
                    .modifier(BlueTextModifier())
                }
                // 分割线
                if isLifetime && isSubScription {
                    Divider().padding(.leading, 40)
                }
                if appStorage.expirationDate > Date().timeIntervalSince1970 {
                    HStack {
                        Image(systemName: "checkmark.seal.fill")
                            .imageScale(.large)
                        Text("Premium Member")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        Spacer()
                        VStack(alignment:.trailing, spacing:3) {
                            // 到期时间
                            Text("Expiry date")
                            #if DEBUG
                            Text(formattedDateTest(date))
                            #else
                            Text(formattedDate(date))
                            #endif
                        }
                        .font(.caption2)
                    }
                    .modifier(BlueTextModifier())
                }
            }
            .modifier(VStackModifier())
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
            if !iapManager.IAPProductList.isEmpty {
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
                                            .modifier(DrakGrayTextModifier())
                                        HStack(spacing: 0) {
                                            Caption2(text: products.displayPrice)
                                            if let priceSuffix = item.priceSuffix {
                                                Footnote(text:"/")
                                                Footnote(text: priceSuffix)
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
                                    // 振动
                                    HapticManager.shared.selectionChanged()
                                    // 如果重复点击内购商品，则清空内购商品
                                    selectedProduct = products
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
                            .modifier(GrayTextModifier())
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
    @Binding var loadPurchased:Bool
    @Binding var isPurchaseSuccessfulView: Bool
    @Binding var purchaseProductTask: Task<Void, Never>?
    @State private var recoverySuccessful = false
    var body: some View {
        VStack(spacing: 10) {
            // 购买会员-按钮
            Button(action: {
                // 振动
                HapticManager.shared.selectionChanged()
                // 显示加载动画
                loadPurchased = true
                // 如果有商品信息，则购买商品。
                if let selectedProduct = selectedProduct {
                    purchaseProductTask = Task {
                        await iapManager.purchaseProduct(selectedProduct) { success in
                            if success == true {
                                isPurchaseSuccessfulView = true
                                // 振动
                                HapticManager.shared.selectionChanged()
                                // 成功音效
                                SoundManager.shared.playSound(named: "successShot")
                            }
                            loadPurchased = false
                            print("success:\(success)")
                        }
                    }
                }
            }, label: {
                VStack(spacing:3) {
                    // 会员信息
                    HStack {
                        Text("Purchase Membership")
                        if let selectedProduct = selectedProduct,let product = iapManager.IAPProductList.first(where: { $0.id == selectedProduct.id }) {
                            Text("(")+Text(LocalizedStringKey(product.name))+Text(")")
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
                .modifier(ButtonModifier3())
            })
            // 恢复购买-按钮
            Button(action: {
                HapticManager.shared.selectionChanged()
                Task {
                    await IAPManager.shared.checkAllTransactions() { success in
                        recoverySuccessful = success
                        // 振动
                        HapticManager.shared.selectionChanged()
                        // 成功音效
                        SoundManager.shared.playSound(named: "successShot")
                    }
                }
            },label: {
                Footnote(text:"Restore Purchases")
            })
            .sheet(isPresented: $recoverySuccessful, content: {
                RecoverySuccessfulView()
                    .presentationDetents([.height(360)])
            })
        }
        .padding(.bottom,10)
        .ignoresSafeArea()
        .onAppear {
            // 如果有产品，则默认选择最后一个产品
            if !iapManager.products.isEmpty {
                selectedProduct = iapManager.products.last
            }
        }
    }
}

// 会员权益-列表
private struct premiumItemView: View {
    var premium: PreminumModel
    var body: some View {
        // 单行
        HStack(spacing: 10) {
            // 图标
            VStack {
                ZStack {
                    Rectangle()
                        .frame(width: 36, height: 36)
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
                    .frame(width: 20)
                    .aspectRatio(1, contentMode: .fit)
                    .foregroundColor(.white)
                }
                Spacer()
            }
            // 标题和描述
            VStack(alignment: .leading, spacing: 3) {
                Text(LocalizedStringKey(premium.text))
                    .font(.subheadline)
                    .modifier(DrakGrayTextModifier())
                Text(LocalizedStringKey(premium.info))
                    .font(.caption)
                    .fixedSize(horizontal: false, vertical: true)
                    .modifier(GrayTextModifier())
            }
            Spacer()
        }
    }
}

private struct VStackModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(10)
            .frame(maxWidth: .infinity,alignment: .leading)
            .modifier(WhiteBgModifier())
            .cornerRadius(10)
    }
}

// 恢复视图
private struct RecoverySuccessfulView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer().frame(height:30)
            LottieView(filename: "BlueAccessVIP", isPlaying: true, playCount: 0, isReversed: false)
                .frame(maxHeight: 150)
                .frame(maxWidth: 500)
            // 恢复成功
            Text("Recovery Successful")
                .modifier(TitleModifier())
            // 高级会员
            HStack(spacing:0) {
                Text("Premium Member")
            }
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundColor(AppColor.appColor)
            Spacer()
            Text("Completed")
                .modifier(ButtonModifier())
                .onTapGesture {
                    dismiss()
                }
        }
    }
}
private struct PurchaseSuccessfulView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            Spacer().frame(height:30)
            LottieView(filename: "BlueAccessVIP", isPlaying: true, playCount: 0, isReversed: false)
                .frame(maxHeight: 150)
                .frame(maxWidth: 500)
            // 购买成功
            Text("Purchase successful")
                .modifier(TitleModifier())
            // 高级会员
            HStack(spacing:0) {
                Text("Premium Member")
            }
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundColor(AppColor.appColor)
            Spacer()
            Text("Completed")
                .modifier(ButtonModifier())
                .onTapGesture {
                    dismiss()
                }
        }
    }
}

#Preview {
    NavigationStack{
        PremiumView()
    }
    .environment(IAPManager.shared)
    .environmentObject(AppStorageManager.shared)
}

#Preview {
    PurchaseSuccessfulView()
}
