//
//  MainInterfaceBackgroundView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    let generator = UISelectionFeedbackGenerator()
    let columns = Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 160), spacing: 16), count: 2)
    var backgroundRange: [Int] {
        Array(0..<39)
    }
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Spacer().frame(height: 10)
                
                // 模糊背景
                HomeSettingNoIconRow(title: "Blur background", accessory: .binding($appStorage.isBlurBackground))
                    .shadow(radius: 1)
                Spacer().frame(height: 20)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    BackgroundItemView(isSelected: appStorage.BackgroundImage.isEmpty) {
                        selectedBackground(nil)
                    }
                    ForEach(backgroundRange, id: \.self) { index in
                        BackgroundItemView(index: index, isSelected: appStorage.BackgroundImage == "bg\(index)") {
                            selectedBackground(index)
                        }
                    }
                }
                // Freepik备注
                FootnoteSourceNotLocalized(text: "Image by freepik")
            }
        }
        .navigationTitle("Background")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal,20)
        .background {
            BackgroundImgView()
        }
    }
    // 点击背景，触发振动
    private func selectedBackground(_ index: Int?) {
        // 振动
        HapticManager.shared.selectionChanged()
        print("更换背景")
        withAnimation {
            if let index = index {
                print("更新壁纸:bg\(index)")
                appStorage.BackgroundImage = "bg\(index)"
            } else {
                print("改为默认壁纸")
                appStorage.BackgroundImage = ""
            }
        }
    }
}

private struct BackgroundItemView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @EnvironmentObject var iapManager: IAPManager
    let index: Int?
    let isSelected: Bool
    let action: () -> Void
    var backgroundLimit: Int = 7 // 免费背景额度
    
    init(index: Int? = nil,isSelected: Bool, action:@escaping () -> Void) {
        self.index = index
        self.isSelected = isSelected
        self.action = action
    }
    
    func isLock(index: Int) -> Bool {
        !appStorage.isValidMember && index >= backgroundLimit
    }
    
    var body: some View {
        ZStack {
            // 选中框
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(isSelected ?  .blue : .clear, lineWidth: 5)
            // 背景图片 & 按钮
            Button(action: {
                action()
            }, label: {
                if let index = index {
                    Image("bg\(index)")
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(10)
                        .scaleEffect(isSelected ? 0.8 : 1)
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(AppColor.appBgGrayColor)
                        .scaleEffect(isSelected ? 0.8 : 1)
                        .shadow(radius: 2)
                }
            })
            .buttonStyle(.plain)
            .overlay {
                if isLock(index: index ?? 0) {
                    LockApp()   // 未解锁的状态
                        .environment(appStorage)
                        .environment(iapManager)
                }
            }
        }
        .frame(width:  140,height: 100)
    }
}

#Preview {
    NavigationStack {
        BackgroundView()
            .environment(AppStorageManager.shared)
    }
}
