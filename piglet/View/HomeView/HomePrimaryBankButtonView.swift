//
//  HomePrimaryBankButtonView.swift
//  piglet
//
//  Created by 方君宇 on 2025/12/3.
//

import SwiftUI

struct HomePrimaryBankButtonView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @State private var showDeleteAlert = false
    @State private var showMoreInformation = false
    var primaryBank: PiggyBank
    let buttonBackground: Color = .white
    let buttonHeight = 50.0
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let buttonWidth = width * 0.23
            HStack(spacing: 0) {
                // 1) 信息按钮
                HomePrimaryBankSingleButtonView(width:buttonWidth,height:buttonHeight,image: "info", name:"Info") {
                    // 振动
                    HapticManager.shared.selectionChanged()
                    showMoreInformation.toggle()
                }
                .sheet(isPresented: $showMoreInformation) {
                    NavigationStack {
                        HomeMoreInformationView(primary: primaryBank)
                    }
                }
                
                Spacer()
                
                // 2) 存入按钮
                HomePrimaryBankSingleButtonView(width:buttonWidth,height:buttonHeight,image: "arrow.down.left", name:"Deposit") {
                    // 振动
                    HapticManager.shared.selectionChanged()
                    homeVM.tardeModel = .deposit
                    homeVM.piggyBank = primaryBank
                    withAnimation(.easeInOut(duration: 1)) { homeVM.isTradeView.toggle() }
                }
                
                Spacer()
                
                // 3) 取出按钮
                HomePrimaryBankSingleButtonView(width:buttonWidth,height:buttonHeight,image: "arrow.up.right", name:"Withdraw") {
                    // 振动
                    HapticManager.shared.selectionChanged()
                    homeVM.tardeModel = .withdraw
                    homeVM.piggyBank = primaryBank
                    withAnimation(.easeInOut(duration: 1)) { homeVM.isTradeView.toggle() }
                }
                
                Spacer()
                
                // 4) 删除按钮
                HomePrimaryBankSingleButtonView(width:buttonWidth,height:buttonHeight,image: "trash", name:"Delete") {
                    // 振动
                    HapticManager.shared.selectionChanged()
                    // 显示删除存钱罐警告框
                    showDeleteAlert.toggle()
                }
                .alert("Delete",isPresented: $showDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        homeVM.deletePiggyBank(for: primaryBank)
                    }
                } message: {
                    Text("Are you sure you want to delete this piggy bank?")
                }
                
            }
        }
        .frame(height:buttonHeight)
    }
}

private struct HomePrimaryBankSingleButtonView: View {
    let width: CGFloat
    let height: CGFloat
    var image: String
    let name: String
    let spacerSpacing = 10.0
    let buttonBackground: Color = Color.white
    var content: () -> Void
    var body: some View {
        Button(action: {
            content()
        }, label: {
            VStack(spacing: spacerSpacing) {
                Image(systemName: image)
                    .imageScale(.small)
                    .frame(height:10)
                Text(LocalizedStringKey(name))
                    .font(.caption2)
            }
            .foregroundColor(AppColor.appColor)
        })
        .frame(width: width,height: height)
        .padding(.vertical,5)
        .contentShape(Rectangle())
        .background(.ultraThickMaterial)
        .cornerRadius(10)
    }
}

#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
