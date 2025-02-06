//
//  Home.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/31.
//

import SwiftUI
import SwiftData

struct Home: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Query(filter: #Predicate<PiggyBank> { $0.isPrimary == true },
           sort: [SortDescriptor(\.creationDate, order: .reverse)]) var piggyBank: [PiggyBank]
    @Query var allPiggyBank: [PiggyBank]
    
    @State private var isPlaying = false
    @State private var isReversed = false   // 取出操作时，为false
    @State private var isProverb = true    // true,可以点击动画输出谚语
    @State private var isDisplayedProverb = false // true，显示谚语
    @State private var isInfo = false   // true，显示详细信息
    @State private var currentProverb: String = ""
    @State private var lastRandomIndexes: [Int] = [] // 保存最近的随机数
    @State private var isDisplaySettings = false    // 显示设置页
    @State private var showDepositAndWithdrawView = false   // 显示存取视图
    @State private var showAccessRecordsView = false    // 显示存取记录视图
    @State private var showMoreInformationView = false  // 显示详细信息视图
    @State private var showManagingView = false // 显示通用视图
    @State private var showDetailView = false
    
    @AppStorage("pageSteps") var pageSteps: Int = 1
    @AppStorage("BackgroundImage") var BackgroundImage = "" // 背景照片
    @AppStorage("LoopAnimation") var LoopAnimation = "Home0" // Lottie动画
    @AppStorage("isLoopAnimation") var isLoopAnimation = false  // 循环动画
    @AppStorage("isTestDetails") var isTestDetails = false
    
    let maxHistorySize = 3 // 历史记录长度
    var difference: Double {
        let differenceNum = piggyBank[0].targetAmount - piggyBank[0].amount
        return differenceNum > 0 ? differenceNum : 0.0
    }
    var savingsProgress: String {
        if piggyBank[0].amount < piggyBank[0].targetAmount * 0.2 {
            // 存入金额小于目标金额的20%，刚刚起步
            return "Just started"
        } else if piggyBank[0].amount < piggyBank[0].targetAmount * 0.4{
            // 存入金额小于目标金额的40%，小于积累
            return "A small accumulation of experience"
        } else if piggyBank[0].amount < piggyBank[0].targetAmount * 0.6{
            // 存入金额小于目标金额的60%，步入正轨
            return "Getting on the right track"
        } else if piggyBank[0].amount < piggyBank[0].targetAmount * 0.8{
            // 存入金额小于目标金额的80%，稳步增长
            return "Steady growth"
            
        } else if piggyBank[0].amount < piggyBank[0].targetAmount {
            // 存入金额小于目标金额，接近目标
            return "Close to the goal"
        } else {
            return "Successfully achieved"
        }
    }
    
    // 随机生成谚语的方法
    func generateUniqueRandomProverb() -> String {
        let range = 0..<22
        var newIndex: Int
        repeat {
            newIndex = Int.random(in: range)
        } while lastRandomIndexes.contains(newIndex) // 避免重复
        // 更新历史记录
        lastRandomIndexes.append(newIndex)
        if lastRandomIndexes.count > maxHistorySize {
            lastRandomIndexes.removeFirst() // 超出长度限制时移除最旧的
        }
        return "proverb" + "\(newIndex)"
    }
    
    
    @ViewBuilder
    private func backgroundImageView() -> some View {
        if !BackgroundImage.isEmpty {
            Image(BackgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .brightness(colorScheme == .dark ? -0.5 : 0) // 让深色模式降低亮度
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                let height = geometry.size.height
                ZStack {
                    // 如果有数据
                    VStack {
                        //  存钱罐显示内容
                        if piggyBank.count != 0 {
                            // 显示存钱罐的储蓄信息
                            Spacer().frame(height: height * 0.05)
                            HStack(spacing: 0) {
                                Circle().fill(.white)
                                    .frame(width: isLandscape ? isPadScreen ? width * 0.06 : width * 0.05 : isPadScreen ? width * 0.08 : isCompactScreen ? width * 0.1 : width * 0.12)
                                    .overlay {
                                        Image(systemName: piggyBank[0].icon)
                                            .font(isCompactScreen ? .footnote : .title3)
                                            .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                    }
                                    .padding(.horizontal,10)
                                    .contentShape(Circle())
                                    .onTapGesture {
                                        showMoreInformationView.toggle()
                                    }
                                    .contextMenu {
                                        Button(action: {
                                            showMoreInformationView.toggle()
                                        }, label: {
                                            Label("Details",systemImage:"list.clipboard")
                                        })
                                    }
                                // 存钱罐顶部储蓄信息
                                VStack(alignment: .leading) {
                                    Group {
                                        if piggyBank[0].amount == piggyBank[0].targetAmount {
                                            Text("Piggy bank full")
                                                .font(.title2)
                                                .fontWeight(.bold).animation(.easeInOut(duration: 0.5), value: difference)
                                        } else {
                                            Text("$ \(difference.formattedWithTwoDecimalPlaces())")
                                                .font(.title2)
                                                .fontWeight(.bold).animation(.easeInOut(duration: 0.5), value: difference)
                                        }
                                        Group {
                                            if  piggyBank[0].amount == piggyBank[0].targetAmount {
                                                Text("Completion date") + Text(piggyBank[0].completionDate,format: .dateTime.year().month().day())
                                            } else {
                                                Text("Distance")+Text(" \(piggyBank[0].name) ") + Text("Need")
                                            }
                                        }
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.8)
                                }
                            }
                            .padding(10)
                            .frame(width: width, height: isLandscape ? isPadScreen ? height * 0.14 : height * 0.2 : isPadScreen ? height * 0.08: isCompactScreen ? height * 0.15 : height * 0.12)
                            .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                            .cornerRadius(10)
                            
                            Spacer().frame(height: isCompactScreen ? 0.02 : height * 0.08)
                            SpacedContainer(isCompactScreen: isCompactScreen) {
                                // 左侧详细信息和存钱记录
                                HStack {
                                    VStack(spacing: 0) {
                                        Group {
                                            // 显示详细信息的按钮
                                            Button(action: {
                                                withAnimation(.easeInOut(duration:0.5)) {
                                                    isTestDetails ? showDetailView.toggle() : isInfo.toggle()
                                                }
                                            }, label: {
                                                VStack {
                                                    Image(systemName: piggyBank[0].icon)
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width:20, height: 20)
                                                }
                                                .frame(width: 40, height: 40)
                                            })
                                            Rectangle()
                                                .fill(.white)
                                                .frame(width: 30, height: 1) // 自定义宽度和高度
                                            
                                            // 显示存取记录的按钮
                                            Button(action: {
                                                showAccessRecordsView.toggle()
                                            }, label: {
                                                VStack {
                                                    Image(systemName: "clock.arrow.circlepath")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20,height: 20)
                                                }
                                                .frame(width: 40, height: 40)
                                            })
                                        }
                                    }
                                    .frame(width: 40,height: 81)
                                    .foregroundColor(.white)
                                    .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                    .cornerRadius(10)
                                    
                                    // 对话内容
                                    HStack(spacing: 0) {
                                        // 左边的三角
                                        LeftTriangle()
                                            .frame(width: 10,height:10)
                                            .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                        // 三角旁边的详细信息框
                                        VStack(alignment:.leading){
                                            Group {
                                                HStack(spacing:3) {
                                                    Text("Target amount")
                                                    Text(":")
                                                    Text("$ \(piggyBank[0].targetAmount.formattedWithTwoDecimalPlaces())")
                                                        .animation(.easeInOut(duration: 0.5), value: piggyBank[0].targetAmount)
                                                }
                                                HStack(spacing:3) {
                                                    Text("Current amount")
                                                    Text(":")
                                                    Text("$ \(piggyBank[0].amount.formattedWithTwoDecimalPlaces())")
                                                        .animation(.easeInOut(duration: 0.5), value: piggyBank[0].amount)
                                                }
                                                HStack(spacing:3) {
                                                    Text("Saving progress")
                                                    Text(":")
                                                    Text(LocalizedStringKey(savingsProgress))
                                                        .animation(.easeInOut(duration: 0.5), value: savingsProgress)
                                                }
                                            }
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.3)
                                            .font(isCompactScreen ? .footnote : .body)
                                            .fontWeight(.bold)
                                            .fixedSize(horizontal: false, vertical: true) // 自动扩展宽度
                                        }
                                        .padding(.vertical,10)
                                        .padding(.horizontal,20)
                                        .foregroundColor(.white)
                                        .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                        .cornerRadius(10)
                                    }
                                    .offset(y: -30)
                                    .opacity(isInfo == true ? 1 : 0)
                                    Spacer()
                                }
                                Spacer().frame(width: 0,height: isLandscape ? 0 : height * 0.02)
                                // 存取猪猪动画
                                HStack {
                                    // 谚语
                                    if isDisplayedProverb {
                                        // 谚语
                                        Spacer()
                                        VStack {
                                            HStack(spacing: 0) {
                                                Group {
                                                    Text(LocalizedStringKey(currentProverb))
                                                        .padding(10)
                                                        .foregroundColor(.white)
                                                        .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                                        .cornerRadius(10)
                                                        .fixedSize(horizontal: false, vertical: true) // 自动扩展宽度
                                                        .lineLimit(7)
                                                        .minimumScaleFactor(0.6)
                                                    RightTriangle()
                                                        .frame(width: 10,height:10)
                                                        .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                                }
                                            }
                                        }
                                        .frame(maxWidth: 300,maxHeight: 50)
                                    } else {
                                        Spacer()
                                    }
                                    VStack {
                                        // 存钱猪猪动画
                                        LottieView(filename: LoopAnimation,isPlaying: isLoopAnimation ? true : isPlaying, playCount: isLoopAnimation ? 0 : 1, isReversed: isLoopAnimation ? false : isReversed)
                                            .id(LoopAnimation) // 关键：确保当 LoopAnimation 变化时，LottieView 重新加载
                                            .scaleEffect(x: layoutDirection == .leftToRight ? AnimationScaleConfig.scale(for: "\(LoopAnimation)") : -AnimationScaleConfig.scale(for: "\(LoopAnimation)"), y: AnimationScaleConfig.scale(for: "\(LoopAnimation)")) // 水平翻转视图
                                            .offset(y: BackgroundImage == "Home0" ? -20 : 0)
                                            .opacity(colorScheme == .light ? 1 : 0.8)
                                            .disabled(isProverb)
                                            .frame(width: 160, height: 160)
                                            .contentShape(Circle())
                                            .onTapGesture {
                                                // 点击动画时刷新谚语
                                                currentProverb = generateUniqueRandomProverb()
                                                withAnimation(.easeInOut(duration: 0.5)) {
                                                    isDisplayedProverb = true
                                                    isProverb = false
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                                        isDisplayedProverb = false
                                                        isProverb = true
                                                    }
                                                }
                                            }
                                            .allowsHitTesting(isProverb)
                                        
                                        // 存钱罐日期
                                        if piggyBank[0].isExpirationDateEnabled {
                                            HStack{
                                                Group {
                                                    Image(systemName: "calendar")
                                                    Spacer().frame(width: 20)
                                                    Text(piggyBank[0].expirationDate,format: .dateTime.year().month().day())
                                                        .fixedSize(horizontal: true, vertical: false) // 自动扩展宽度
                                                }
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            
                            Spacer()
                            
                            // 存入取出按钮
                            Button(action: {
                                showDepositAndWithdrawView.toggle()
                            }, label: {
                                Text("Deposit/withdraw")
                                    .frame(width: 320,height: 60)
                                    .foregroundColor(Color.white)
                                    .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                    .cornerRadius(10)
                            })
                            // 底部留白为50高度
                            Spacer().frame(height: height * 0.05)
                        }  else {
                            // 空白占位符
                            Spacer()
                            if !isCompactScreen {
                                Group {
                                    Image("empty")
                                        .resizable()
                                        .scaledToFit()
                                    Spacer().frame(height: 20)
                                    Text("Image by freepik")
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .offset(y: -20)
                                }
                                .frame(width: width * 0.8)
                            }
                            Spacer().frame(height: height * 0.05)
                            // 未创建存钱罐提示
                            Group {
                                Text("You haven't created it yet")
                                Text("Piggy Bank")
                            }
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .multilineTextAlignment(.center)
                            
                            Spacer().frame(height: 20)
                            Text("Let the piggy bank record your every growth and expectation.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                            Spacer()
                            Button(action: {
                                // 跳转到创建视图
                                pageSteps = 3
                            }, label: {
                                Text("Create")
                                    .frame(width: 320,height: 60)
                                    .foregroundColor(Color.white)
                                    .background(Color(hex: "#FF4B00"))
                                    .cornerRadius(10)
                            })
                            Spacer().frame(height: height * 0.05)
                        }
                    }
                    .frame(width: width)
                    .sheet(isPresented: $showMoreInformationView, content: {
                        MoreInformationView()
                    })
                    .sheet(isPresented: $isDisplaySettings) {
                        Settings()
                    }
                    .sheet(isPresented: $showAccessRecordsView) {
                        AccessRecordsView(piggyBank: piggyBank[0])
                    }
                    // 管理视图
                    .sheet(isPresented: $showManagingView, content: {
                        ManagingView()
                            .presentationDetents([.height(260)])
                    })
                    
                    // 详细信息（缩略）视图
                    .sheet(isPresented: $showDetailView, content: {
                        DetailView(CurrentAmount: piggyBank[0].amount, TargetAmount: piggyBank[0].targetAmount)
                            .presentationDetents([.height(300)])
                    })
                    .sheet(isPresented: $showDepositAndWithdrawView, content: {
                        DepositAndWithdrawView(isReversed: $isReversed) {
                            isPlaying = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                isPlaying = false
                            }
                        }
                    })
                    .onTapGesture {
                        withAnimation(.easeInOut(duration:0.5)) {
                            isInfo = false
                        }
                    }
                    .navigationTitle("Banklet")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        // 左上角管理按钮
                        ToolbarItem(placement:.topBarLeading) {
                            Menu(content: {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        showManagingView.toggle()
                                    }
                                }, label: {
                                    HStack {
                                        Text("Manage")
                                        Spacer()
                                        Image(systemName: "pin")
                                    }
                                })
                            }, label: {
                                Image(colorScheme == .light ? "iconWhite" : "iconWhiteDark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                            })
                        }
                        // 右上角设置按钮
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                isDisplaySettings.toggle()
                            }, label: {
                                Image(systemName: "gearshape")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                            })
                        }
                    }
                }
                .frame(maxWidth:  geometry.size.width,maxHeight: geometry.size.height)
                .background(
                    backgroundImageView()
                )
            }
        }
    }
}

#Preview {
    @StateObject var iapManager = IAPManager.shared
    return Home()
        .modelContainer(PiggyBank.preview)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
    //        .environmentObject(iapManager).environment(\.locale, .init(identifier: "de"))
}
