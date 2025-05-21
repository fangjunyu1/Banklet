//
//  AppIconView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/27.
//

import SwiftUI

class TransparentViewController: UIViewController {
    override func viewDidLoad() {
        print("进入viewDidLoad方法")
        super.viewDidLoad()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0) // 完全透明
        backgroundView.frame = view.bounds
        view.addSubview(backgroundView)
        print("完成 backgroundView 的添加")
    }
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        print("进入 present 方法")
        if viewControllerToPresent is UIAlertController {
            print("拦截了系统弹窗")
            completion?()
            dismiss(animated: false)
        } else {
            print("不是系统弹窗，执行 dismiss")
            completion?()
            dismiss(animated: false)
        }
        print("完成 present 方法")
    }
}

class IconChanger {
    static func changeIconSilently(to name: String?,completion: @escaping(Bool) -> Void) {
        print("进入 changeIconSilently 方法")
        guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
              let rootVC = windowScene.windows.first?.rootViewController else {
            // 安全地拿到当前活跃窗口的根控制器
               print("无法找到 rootVC，退出方法")
               completion(false)
               return
        }
        
        print("当前的 rootVC 是：\(type(of: rootVC))")
        var topVC = rootVC
        while let presented = topVC.presentedViewController {
            topVC = presented
        }
        
        let transparentVC = TransparentViewController()
        transparentVC.modalPresentationStyle = .overFullScreen
        
        if !(topVC is TransparentViewController) && !(topVC is UIAlertController) {
            topVC.present(transparentVC, animated: false) {
                UIApplication.shared.setAlternateIconName(name) { error in
                    DispatchQueue.main.async {
                        print("进入主线程闭包")
                        transparentVC.dismiss(animated: false) // 主动关闭
                        print("进入主线程闭包的判断")
                        if error == nil {
                            print("设置 App Icon成功！！")
                            completion(true)
                        } else {
                            print("设置 App Icon 出错：\(error?.localizedDescription ?? "")！！")
                            completion(false)
                        }
                    }
                }
            }
        } else {
            // 已有其他控制器，无法静默处理
            print("topVC 判断出错，设置 App Icon 出错")
            completion(false)
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
    
    // 更换图标方法
    func setAlternateIconNameFunc(name: String) {
        IconChanger.changeIconSilently(to: name) { success in
            if success {
                appStorage.appIcon = name ?? "AppIcon 2"
                selectedIconName = name
                print("设置了\(name)为图标")
            }
        }
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
