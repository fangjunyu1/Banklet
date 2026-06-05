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
    @Environment(\.dismiss) var dismiss
    @Environment(AppStorageManager.self) var appStorage
    @EnvironmentObject var iapManager: IAPManager
    @State private var selectedProductID: String?
    @State private var isLoading = false    // 加载画布
    @State private var operationTask: Task<Void, Never>?    // 内购 Task
    @State private var productResultStatus: ProductResultEnum?
    
    var showCloseButton: Bool = false
    
    // 年度会员 ID
    private let yearlyProductID = "20240523"
    
    // 已选择的产品
    private var selectedProduct: Product? {
        iapManager.displayProducts
            .first { $0.product.id == selectedProductID }?
            .product
    }
    
    // 选择年度会员
    private func selectDefaultProductIfNeeded() {
        let products = iapManager.displayProducts
        
        guard !products.isEmpty else {
            return
        }
        
        // 如果当前已选择的商品仍然存在，就不重复覆盖用户选择
        if let selectedProductID,
           products.contains(where: { $0.product.id == selectedProductID }) {
            return
        }
        
        selectedProductID =
        products.first(where: { $0.product.id == yearlyProductID })?.product.id
        ?? products.first?.product.id
    }
    
    var body: some View {
        ZStack {
            VStack {
                // 显示列表
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        proAnimation
                        proTitle
                        // 如果有会员才显示
                        if appStorage.isValidMember {
                            CurrentPlanView()
                        }
                        if !iapManager.displayProducts.isEmpty {
                            chooseAPlan
                        }
                        included
                        purchaseNotice
                        Spacer()
                    }
                }
                
                VStack(spacing: 14) {
                    subscribeButton
                    restorePurchasesButton
                }
                .padding(.top, 10)
                .padding(.bottom, 50)
            }
            .navigationTitle("Pro")
            .modifier(BackgroundModifier())
            
            if isLoading {
                loadingView
            }
        }
        .sheet(item: $productResultStatus) { result in
            ProductResultView(result: result)
                .environmentObject(appStorage)
                .environmentObject(iapManager)
        }
        .task {
            if iapManager.displayProducts.isEmpty {
                await iapManager.loadProduct()
                selectDefaultProductIfNeeded()
            }
        }
        .safeAreaInset(edge: .top) {
            if showCloseButton {
                closeButton
            }
        }
    }
    
    // 关闭视图
    var closeButton: some View {
        HStack {
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title.bold())
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(30)
    }
    
    // 加载视图
    var loadingView: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        // 振动
                        HapticManager.shared.selectionChanged()
                        isLoading.toggle()
                        operationTask?.cancel()   // 取消购买任务
                        operationTask = nil
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
                .modifier(WhiteBgModifier())
                .cornerRadius(10)
                .opacity(0.8)
        }
    }
    
    // 动画
    var proAnimation: some View {
        ReadyStage()
            .scaleEffect(0.8)
            .frame(height: 160)
    }
    
    // 会员文本
    var proTitle: some View {
        VStack(spacing: 15) {
            // 储蓄每一个梦想
            Text("Saving every dream")
                .modifier(TitleModifier())
            Text("Give your piggy bank a fresh new look with more customization options, smoother animations, and unique themes.")
                .modifier(FootNoteModifier())
        }
    }
    
    // 选择方案
    var chooseAPlan: some View {
        VStack {
            // 选择方案
            HStack {
                Footnote(text: "Choose a solution")
                Spacer()
            }
            // 选择方案-列表
            VStack(spacing: 10) {
                ForEach(iapManager.displayProducts) { product in
                    let isSelected: Bool = selectedProductID == product.product.id
                    Button(action: {
                        HapticManager.shared.selectionChanged()
                        selectedProductID = product.product.id
                    }, label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(product.displayName)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    if let tag = product.info.tag, let tagColor = product.info.tagColor {
                                        Text(tag)
                                            .font(.caption2)
                                            .fontWeight(.bold)
                                            .padding(.vertical,3)
                                            .padding(.horizontal, 8)
                                            .foregroundStyle(tagColor)
                                            .background(tagColor.opacity(0.15))
                                            .clipShape(RoundedRectangle(cornerRadius: 3))
                                    }
                                }
                                HStack(spacing: 5) {
                                    Text(product.displayPrice)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    HStack(spacing: 2) {
                                        Text(verbatim: "/")
                                        Text(product.info.priceSuffix)
                                    }
                                    .font(.footnote)
                                    .foregroundStyle(.secondary)
                                }
                            }
                            
                            Spacer()
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .imageScale(.large)
                                .foregroundStyle(isSelected ? AppColor.appColor : Color.gray)
                        }
                        .frame(height: 60)
                        .modifier(ProBg())
                        .overlay {
                            if isSelected {
                                RoundedRectangle(cornerRadius: 12)
                                    .strokeBorder(AppColor.appColor, lineWidth: 3)
                            }
                        }
                        .overlay {
                            if product.info.isRecommend {
                                VStack {
                                    HStack {
                                        Spacer()
                                        Text("Recommended")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundStyle(Color.white)
                                            .padding(3)
                                            .padding(.horizontal, 8)
                                            .background(AppColor.appColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 5))
                                    }
                                    Spacer()
                                }
                            }
                        }
                    })
                    .buttonStyle(.plain)
                }
            }
        }
        .onAppear {
            selectDefaultProductIfNeeded()
        }
        .onChange(of: iapManager.displayProducts.map { $0.product.id }) { _,_ in
            selectDefaultProductIfNeeded()
        }
    }
    
    // 包含内容
    var included: some View {
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
    }
    
    // 购买提示
    var purchaseNotice: some View {
        VStack(spacing: 10) {
            HStack {
                Footnote(text: "Purchase Tips")
                Spacer()
            }
            HStack {
                VStack(alignment: .leading) {
                    // 订阅会自动续费，除非在 App Store 账户中取消。
                    Text("The subscription will automatically renew unless canceled in your App Store account.")
                    // 已购买会员可通过“恢复购买”找回。
                    Text("Members who have already purchased memberships can retrieve them through the \"Restore Purchase\" function.")
                    // 永久会员一次购买，永久有效，无需续费。
                    Text("A lifetime membership is a one-time purchase that is valid indefinitely and requires no renewal.",)
                    // 如需退订，请在 App Store → 账户 → 购买历史操作，开发者无法代为退订或退款。
                    Text("To unsubscribe, please go to App Store → Account → Purchase History. The developer cannot unsubscribe or issue a refund on your behalf.")
                }
                Spacer()
            }
            .font(.caption2)
            .modifier(GrayTextModifier())
            .modifier(VStackModifier())
        }
    }
    
    // 恢复购买
    var restorePurchasesButton: some View {
        VStack {
            Button(action: {
                // 触发振动
                HapticManager.shared.selectionChanged()
                // 显示加载动画
                isLoading = true
                
                operationTask = Task {
                    await iapManager.checkAllTransactions {
                        result in
                        print("完成恢复购买")
                        // 移除加载动画
                        isLoading = false
                        // 弹出完成提示
                        switch result {
                        case .restoreSuccess:
                            print("恢复成功")
                            productResultStatus = .restoreSuccess
                            SoundManager.shared.playSound(named: "successShot")
                        case .restoreFailed:
                            print("恢复失败")
                            productResultStatus = .restoreFailed
                        default:
                            print("进入其他选择")
                            break
                        }
                    }
                }
            }, label: {
                Footnote(text:"Restore Purchases")
            })
            .buttonStyle(.plain)
        }
    }
    
    // 立即订阅
    var subscribeButton: some View {
        VStack {
            Button(action: {
                print("开始内购商品")
                // 触发振动
                HapticManager.shared.selectionChanged()
                
                guard let selectedProduct else { return }
                // 显示加载动画
                isLoading = true
                
                operationTask = Task {
                    await iapManager.purchaseProduct(selectedProduct) { result in
                        print("完成购买")
                        // 移除加载动画
                        isLoading = false
                        
                        // 弹出完成提示
                        switch result {
                        case .purchaseSuccess:
                            productResultStatus = .purchaseSuccess
                            // 成功音效
                            SoundManager.shared.playSound(named: "successShot")
                        case .purchaseFailed:
                            productResultStatus = .purchaseFailed
                        default:
                            break
                        }
                    }
                }
            }, label: {
                Text("Subscribe Now")
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .foregroundColor(.white)
                    .frame(width: 240,height: 60)
                    .background(selectedProduct == nil ? Color.gray : AppColor.appColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            })
            .disabled(selectedProduct == nil)
        }
    }
}

enum ProductResultEnum: String, Identifiable {
    var id: String {
        rawValue
    }
    case purchaseSuccess
    case purchaseFailed
    case restoreSuccess
    case restoreFailed
    case stateless
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
                Text("Pro")
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
        VStack(spacing: 20) {
            LottieView(filename: "BlueAccessVIP", isPlaying: true, playCount: 0, isReversed: false)
                .frame(maxHeight: 150)
                .frame(maxWidth: 500)
            VStack {
                // 购买成功
                Text("Purchase successful")
                    .modifier(TitleModifier())
                // 高级会员
                HStack(spacing:0) {
                    Text("Pro")
                }
                .font(.footnote)
                .fontWeight(.medium)
                .foregroundColor(AppColor.appColor)
            }
            Spacer()
            Text("Completed")
                .modifier(ButtonModifier())
                .onTapGesture {
                    dismiss()
                }
        }
        .padding(.vertical, 20)
        .frame(height: 360)
    }
}

#Preview {
    NavigationStack{
        PremiumView()
    }
    .environment(IAPManager.shared)
    .environmentObject(AppStorageManager.shared)
}

struct ReadyStage: View {
    @State private var animateIn = false
    
    var backgroundRadialGradientRadius: Double = 150
    
    var backgroundRadialGradientSize: Double = 160
    
    var viewSize: Double = 200
    
    var body: some View {
        ZStack {
            Image("AppIcon 0")
                .resizable()
                .scaledToFit()
                .frame(width: 140)
                .cornerRadius(30)
                .overlay {
                    Image("start")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .offset(x: 60, y: -60)
                        .scaleEffect(animateIn ? 1 : 0.2)
                        .opacity(animateIn ? 1 : 0)
                        .animation(.spring(response: 0.45, dampingFraction: 0.75).delay(0.15), value: animateIn)
                }
                .rotationEffect(.degrees(animateIn ? 0 : -180))
                .scaleEffect(animateIn ? 1 : 0.5)
                .opacity(animateIn ? 1 : 0)
                .background {
                    RadialGradient(
                        gradient: Gradient(colors: [Color(hex: "1000E3")]),
                        center: .center,
                        startRadius: 20,
                        endRadius: backgroundRadialGradientRadius
                    )
                    .frame(width: backgroundRadialGradientSize, height: backgroundRadialGradientSize)
                    .opacity(0.5)
                    .cornerRadius(90)
                    .blur(radius: 30)
                }
                .frame(height: viewSize)
                .animation(.spring(response: 0.65, dampingFraction: 0.8), value: animateIn)
            
            RotatingBorderView()
        }
        .onAppear {
            animateIn = true
        }
    }
}

#Preview {
    PurchaseSuccessfulView()
}
