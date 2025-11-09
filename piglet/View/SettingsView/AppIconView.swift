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
    
    @State private var selectedIconName: String = UIApplication.shared.alternateIconName ?? "AppIcon 2"
    
    let generator = UISelectionFeedbackGenerator()
    
    let columns = [
        GridItem(.adaptive(minimum: 100, maximum: 120)), // 控制列宽范围
        GridItem(.adaptive(minimum: 100, maximum: 120)),
        GridItem(.adaptive(minimum: 100, maximum: 120))
    ]
    
    var appIcon: [Int] {
        //        Array(appStorage.isInAppPurchase ? 0..<36 : 0..<6)
        Array(0..<36)
    }
    
    var appIconLimit: Int = 6   // 免费应用为6个
    func selectIcon(num: Int) -> Bool{
        selectedIconName == "AppIcon \(num)" ? true : false
    }
    var body: some View {
        VStack {
            Spacer().frame(height: 10)
            Text("Current icon")
                .font(.footnote)
                .foregroundColor(.gray)
            HStack(alignment: .center) {
                Image(selectedIconName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                    .frame(width: 95,height: 95)
            }
            Spacer().frame(height: 20)
            HStack {
                Text("All icons")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
            }
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
                            if !appStorage.isInAppPurchase && index >= appIconLimit {
                                lockApp()   // 未解锁的状态
                            }
                        }
                    }
                }
                Spacer().frame(height:20)
                // Freepik备注
                HStack(alignment: .center) {
                    Text("Image by freepik")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
        .navigationTitle("icon")
        .modifier(BackgroundModifier())
    }
    
    private func handleTap(iconName: String) {
        if appStorage.isVibration {
            // 发生振动
            generator.prepare()
            generator.selectionChanged()
        }
        IconChanger.changeIconSilently(to: iconName,selected: $selectedIconName)
        print("点击了:\(iconName)")
    }
}

private struct lockApp: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "lock.fill")
                    .imageScale(.small)
                    .padding(.vertical,6)
                    .padding(.horizontal,10)
                    .foregroundColor(.white)
                    .background(AppColor.appColor)
                    .cornerRadius(5)
            }
        }
        .background {
            Color.black.opacity(0.1).cornerRadius(10)
        }
    }
}
#Preview {
    NavigationStack {
        AppIconView()
            .environment(AppStorageManager.shared)
    }
}
