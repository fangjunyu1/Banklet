//
//  AppIconView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/27.
//

import SwiftUI

struct AppIconView: View {
    
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    
    @State private var selectedIconName: String = UIApplication.shared.alternateIconName ?? "AppIcon 2"
    
    let generator = UISelectionFeedbackGenerator()
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120)), // 控制列宽范围
        GridItem(.adaptive(minimum: 100, maximum: 120)),
        GridItem(.adaptive(minimum: 100, maximum: 120))
    ]
    
    let columnsIpad = [
        GridItem(.adaptive(minimum: 130, maximum: 155)), // 控制列宽范围
        GridItem(.adaptive(minimum: 130, maximum: 155)),
        GridItem(.adaptive(minimum: 130, maximum: 155))
    ]
    
    var appIcon: [Int] {
        //        Array(appStorage.isInAppPurchase ? 0..<36 : 0..<6)
        Array(0..<36)
    }
    
    var appIconLimit: Int = 6
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                
                ZStack {
                    // 背景
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    ScrollView(showsIndicators: false ) {
                        LazyVGrid(columns:  columns,spacing: 20) {
                            ForEach(appIcon, id: \.self) { index in
                                Button(action: {
                                    if appStorage.isVibration {
                                        // 发生振动
                                        generator.prepare()
                                        generator.selectionChanged()
                                    }
                                    IconChanger.changeIconSilently(to: "AppIcon \(index)",selected: $selectedIconName)
                                    print("点击了:AppIcon \(index)")
                                }, label: {
                                    Rectangle()
                                        .strokeBorder(selectedIconName == "AppIcon \(index)" ? .blue : .clear, lineWidth: 5)
                                        .foregroundColor(.white)
                                        .frame(width: 100,height:  100)
                                        .cornerRadius(10)
                                        .clipped()
                                        .overlay {
                                            Image(uiImage: UIImage(named: "AppIcon \(index)") ?? UIImage())
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width:  95,height: 95)
                                                .cornerRadius(10)
                                                .clipped()
                                                .overlay {
                                                    if selectedIconName == "AppIcon \(index)" {
                                                        VStack {
                                                            Spacer()
                                                            HStack {
                                                                Spacer()
                                                                Image(systemName: "checkmark.circle.fill")
                                                                    .foregroundColor(colorScheme == .light ? .blue : .white)
                                                                    .font(.title)
                                                                    .padding(10)
                                                            }
                                                        }
                                                    }
                                                }
                                        }
                                })
                                .overlay {
                                    if !appStorage.isInAppPurchase && index >= appIconLimit {
                                        ZStack {
                                            Color.black.opacity(0.3)
                                                .cornerRadius(10)
                                            VStack {
                                                Spacer()
                                                HStack {
                                                    Spacer()
                                                    Image(systemName: "lock.fill")
                                                        .imageScale(.large)
                                                        .padding(10)
                                                        .foregroundColor(.white)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                        .frame(width: width)
                        .frame(maxWidth: .infinity,maxHeight: .infinity)
                        .navigationTitle("icon")
                        .navigationBarTitleDisplayMode(.inline)
                        .padding(.vertical,20)
                        Text("Image by freepik")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    AppIconView()
        .environment(AppStorageManager.shared)
        .modelContainer(PiggyBank.preview)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
