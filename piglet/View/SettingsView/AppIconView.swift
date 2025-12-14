//
//  AppIconView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/27.
//

import SwiftUI

struct AppIconView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @State private var selectedIconName: String = UIApplication.shared.alternateIconName ?? "AppIcon 0"
    
    let generator = UISelectionFeedbackGenerator()
    
    let columns = Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 120)), count: 3)
    
    var appIcon: [Int] {
        Array(0..<36)
    }
    
    var appIconLimit: Int = 6   // 免费应用为6个
    func selectIcon(num: Int) -> Bool{
        selectedIconName == "AppIcon \(num)" ? true : false
    }
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            // 当前图标
            Footnote(text: "Current icon")
            HStack(alignment: .center) {
                Image(selectedIconName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 95,height: 95)
            }
            Spacer().frame(height: 20)
            // 所有图标
            HStack {
                Footnote(text: "All icons")
                Spacer()
            }
            // 图标列表
            ScrollView(showsIndicators: false ) {
                LazyVGrid(columns:  columns,spacing: 20) {
                    ForEach(appIcon, id: \.self) { index in
                        let iconName = "AppIcon \(index)"
                        Button(action: {
                            handleTap(iconName:iconName)
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(selectIcon(num:index) ? .blue : .clear, lineWidth: 6)
                                    .frame(width: 100,height: 100)
                                    .foregroundColor(.white)
                                Image(iconName)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                                    .frame(width:  95,height: 95)
                                    .scaleEffect(selectIcon(num:index) ? 0.8 : 1)
                            }
                        })
                        .overlay {
                            // 未内购的图标
                            if !appStorage.isValidMember && index >= appIconLimit {
                                LockApp()   // 未解锁的状态
                            }
                        }
                    }
                }
                // Freepik备注
                FootnoteSource(text: "Image by freepik")
            }
        }
        .navigationTitle("Icon")
        .modifier(BackgroundModifier())
    }
    
    private func handleTap(iconName: String) {
        // 振动
        HapticManager.shared.selectionChanged()
        IconChanger.changeIconSilently(to: iconName,selected: $selectedIconName)
    }
}

#Preview {
    NavigationStack {
        AppIconView()
            .environment(AppStorageManager.shared)
    }
}
