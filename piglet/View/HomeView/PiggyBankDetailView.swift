//
//  PiggyBankDetailView.swift
//  piglet
//
//  Created by 方君宇 on 2026/10/29.
//

import SwiftUI
import SwiftData

struct PiggyBankDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    // 当前存钱罐
    var piggyBank: PiggyBank
    let namespace: Namespace.ID
    // 删除存钱罐闭包
    let onDelete: () -> Void
    
    var body: some View {
        
        // 存钱罐内容
        ScrollView {
            VStack {
                VStack(spacing: 0) {
                    // 存钱罐图标
                    piggyBank.getImg
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 180)
                    
                    // 存钱罐名称
                    OutlinedText(
                        text: piggyBank.name,
                        fontSize: 20,
                        fontWeight: .bold,
                        foregroundColor: .black,
                        strokeColor: .white,
                        strokeWidth: 10,
                        maxWidth: 300
                    )
                    
                    // 存钱罐金额
                    OutlinedText(
                        text: piggyBank.amountText,
                        fontSize: 40,
                        fontWeight: .bold,
                        foregroundColor: .black,
                        strokeColor: .white,
                        strokeWidth: 10,
                        maxWidth: 300
                    )
                    .frame(height: 36)
                }
                
                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Text("Delete")
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 10)
                        .frame(width: 280, height: 60)
                        .foregroundStyle(.red)
                        .background(.white)
                        .cornerRadius(10)
                        .overlay {
                            if colorScheme == .light {
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.red, lineWidth: 1)
                            }
                        }
                }
            }
            Spacer()
            
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    @Previewable @Namespace var namespace
    
    return PiggyBankDetailView(
        piggyBank: PiggyBank.PiggyBanks[0],
        namespace: namespace
    ) {
        // 不传递删除逻辑
    }
    .modelContainer(PiggyBank.preview)
    .environment(SoundManager.shared)
    .environment(AppStorageManager.shared)
    .environment(IAPManager.shared)
    .environment(ModelConfigManager.shared)
}
