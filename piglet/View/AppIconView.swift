//
//  AppIconView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/27.
//

import SwiftUI

class TransparentViewController: UIViewController {
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if viewControllerToPresent is UIAlertController {
            print("拦截了系统弹窗")
             dismiss(animated: false)
//            completion?()
        } else {
            super.present(viewControllerToPresent, animated: flag,completion: completion)
        }
    }
}

class IconChanger {
    static func changeIconSilently(to name: String?,selected: Binding<String>) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let rootVC = windowScene.windows.first?.rootViewController else {
            // 安全地拿到当前活跃窗口的根控制器
            print("无法找到 rootVC，退出方法")
            return
        }
        
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        
        let transparentVC = TransparentViewController()
        transparentVC.modalPresentationStyle = .overFullScreen
        
        if !(topVC is TransparentViewController) && !(topVC is UIAlertController) {
            topVC.present(transparentVC, animated: false)
            if UIApplication.shared.supportsAlternateIcons {
                print("支持功能图标的功能")
                UIApplication.shared.setAlternateIconName(name)
                DispatchQueue.main.async {
                    // 修改存储的图标名称
                    AppStorageManager.shared.appIcon = name ?? "AppIcon 2"
                    selected.wrappedValue = AppStorageManager.shared.appIcon
                }
            } else {
                print("不支持更换图标功能")
            }
        } else {
            // 已有其他控制器，无法静默处理
            print("topVC 判断出错，设置 App Icon 出错")
        }
    }
}

struct AppIconView: View {
    
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
                                    IconChanger.changeIconSilently(to: "AppIcon \(index)",selected: $selectedIconName)
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
