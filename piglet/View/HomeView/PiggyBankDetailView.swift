//
//  PiggyBankDetailView.swift
//  piglet
//
//  Created by 方君宇 on 2026/10/29.
//

import SwiftUI
import SwiftData

struct CoreImageBorderView: View {
    let image: UIImage
    @State private var borderOverlay: UIImage?
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .onAppear {
                    generateBorderOverlay()
                }
            
            if let borderOverlay = borderOverlay {
                Image(uiImage: borderOverlay)
                    .resizable()
                    .scaledToFit()
                    .blendMode(.overlay)
                    .opacity(1.0)
            }
        }
    }
    
    private func generateBorderOverlay() {
        guard let cgImage = image.cgImage else { return }
        let ciImage = CIImage(cgImage: cgImage)
        
        let edgeFilter = CIFilter.edges()
        edgeFilter.inputImage = ciImage
        edgeFilter.intensity = 1.0 // 调整强度控制边框粗细
        
        guard let outputImage = edgeFilter.outputImage else { return }
        let context = CIContext()
        if let cgOutput = context.createCGImage(outputImage, from: outputImage.extent) {
            borderOverlay = UIImage(cgImage: cgOutput)
        }
    }
}

struct PiggyBankDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    // 当前存钱罐
    var piggyBank: PiggyBank
    let namespace: Namespace.ID
    // 删除存钱罐闭包
    let onDelete: () -> Void
    
    var body: some View {
        ZStack {
            Background()
            
            // 存钱罐内容
            ScrollView {
                VStack {
                    VStack(spacing: 0) {
                        // 存钱罐图标
                        OutlinedImageView(
                            name: piggyBank.getImg
                        )
                        .frame(maxWidth: 150)
                                                
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
                        if let targetAmount = piggyBank.targetAmountText {
                            OutlinedText(
                                text: targetAmount,
                                fontSize: 40,
                                fontWeight: .bold,
                                foregroundColor: .black,
                                strokeColor: .white,
                                strokeWidth: 10,
                                maxWidth: 300
                            )
                            .frame(height: 36)
                        }
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
                            .cornerRadius(20)
                            .overlay {
                                if colorScheme == .light {
                                    RoundedRectangle(cornerRadius: 20)
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
}

#Preview {
    @Previewable @Namespace var namespace
    
    PiggyBankDetailView(
        piggyBank: PiggyBank.PiggyBanks[0],
        namespace: namespace
    ) {
        // 不传递删除逻辑
    }
    .modelContainer(PiggyBank.preview)
    .environment(SoundManager.shared)
    .environment(AppStorageManager.shared)
    .environment(IAPManager.shared)
}
