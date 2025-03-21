//
//  AppIconView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/27.
//

import SwiftUI

struct AppIconView: View {
//    @AppStorage("20240523") var isInAppPurchase = false // 内购完成后，设置为true
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    
    @State private var selectedIconName: String = UIApplication.shared.alternateIconName ?? "AppIcon 2"
    
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
    // 1.0.5版本应用图标名称： AppIcon3
//    var AlternateIconName: String {
//        UIApplication.shared.alternateIconName ?? "AppIcon 2"
//    }
    
    // 更换图标方法
    func setAlternateIconNameFunc(name: String) {
        UIApplication.shared.setAlternateIconName(name) { error in
            if error == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.selectedIconName = name
                }
            } else {
                print("更换图标失败: \(error?.localizedDescription ?? "")")
            }
        }
        print("设置了\(name)为图标")
    }
    
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
                        LazyVGrid(columns: isPadScreen ? columnsIpad : columns,spacing: 20) {
                            ForEach(appIcon, id: \.self) { index in
                                Button(action: {
                                    setAlternateIconNameFunc(name: "AppIcon \(index)")
                                    print("点击了:AppIcon \(index)")
                                }, label: {
                                    Rectangle()
                                        .strokeBorder(selectedIconName == "AppIcon \(index)" ? .blue : .clear, lineWidth: 5)
                                        .foregroundColor(.white)
                                        .frame(width: isPadScreen ? 150 : 100,height: isPadScreen ? 150 : 100)
                                        .cornerRadius(10)
                                        .clipped()
                                        .overlay {
                                            Image(uiImage: UIImage(named: "AppIcon \(index)") ?? UIImage())
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: isPadScreen ? 140 : 95,height: isPadScreen ? 140 : 95)
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
}
