//
//  Home.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/20.
//

import SwiftUI
import WatchConnectivity

struct CircularProgressBar: View {
    var progress: CGFloat  // 进度值，范围从 0 到 1
    
    var body: some View {
        ZStack {
            // 背景圆圈
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(Color.gray.opacity(0.3))
            
            // 进度圆圈
            Circle()
                .trim(from: 0, to: progress)  // 根据进度值裁剪
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: -90))  // 使圆圈从顶部开始
                .animation(.easeInOut, value: progress)
        }
        .frame(width: 80, height: 80)  // 设置圆形大小
    }
}

struct Home: View {
    @Environment(WatchSessionDelegate.self) var wcSessionDelegateImpl // 从环境中读取 Person
    
    
    var body: some View {
        VStack {
            
            if !wcSessionDelegateImpl.piggyBanks.isEmpty {
                var mainPiggyBank: PiggyBank {
                    return wcSessionDelegateImpl.piggyBanks.filter({ $0.isPrimary == true }).first!
                }
                var SavingPercentage: Double {
                    // 使用 if let 来解包 optional 值
                    return mainPiggyBank.amount / mainPiggyBank.targetAmount  // 两个非 optional 的值可以进行运算
                }
                CircularProgressBar(progress: SavingPercentage)
                    .overlay {
                        VStack {
                            Image(systemName: "\( mainPiggyBank.icon)")
                            Spacer().frame(height: 10)
                            Text(SavingPercentage, format: .percent.precision(.fractionLength(2)))
                        }
                        .font(.footnote)
                    }
                Spacer().frame(height: 10)
                Text("\(mainPiggyBank.name)")
                    .font(.footnote)
            } else {
                Image("emptyBox")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .onTapGesture {
                        if WCSession.default.isReachable {
                            print("iOS与Watch链接成功")
                        } else {
                            print("iOS与Watch未连接")
                        }
                    }
            }
        }
    }
}

#Preview {
    Home()
        .environment(WatchSessionDelegate())
}
