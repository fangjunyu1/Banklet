//
//  Home.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/31.
//

import SwiftUI
import SwiftData
import Combine
import WidgetKit

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
    @State private var isProverb = true    // true,显示谚语时，变量为false表示动画不可点击
    @State private var isDisplayedProverb = false // true，显示谚语
    //    @State private var isInfo = false   // true，显示详细信息
    @State private var currentProverb: String = ""
    @State private var lastRandomIndexes: [Int] = [] // 保存最近的随机数
    @State private var isDisplaySettings = false    // 显示设置页
    @State private var showDepositAndWithdrawView = false   // 显示存取视图
    @State private var showAccessRecordsView = false    // 显示存取记录视图
    @State private var showMoreInformationView = false  // 显示详细信息视图
    @State private var showManagingView = false // 显示通用视图
    @State private var showStatistics = false   // 显示统计视图
    @State private var showDetailView = false
    // 静默模式
    @State private var isSilentModeActive = false
    // 上次交互时间，超过设定的时间显示静默模式
    @State private var lastInteractionTime = Date()
    // 静默模式计时器
    @State private var timerCancellable: Cancellable? // 用于控制 Timer 的生命周期
    
    @AppStorage("pageSteps") var pageSteps: Int = 1
    @AppStorage("BackgroundImage") var BackgroundImage = "" // 背景照片
    @AppStorage("LoopAnimation") var LoopAnimation = "Home0" // Lottie动画
    @AppStorage("isLoopAnimation") var isLoopAnimation = false  // 循环动画
    //    @AppStorage("isTestDetails") var isTestDetails = false
    // 静默模式
    @AppStorage("isSilentMode") var isSilentMode = false
    // 货币符号
    @AppStorage("CurrencySymbol") var CurrencySymbol = "USD"
    
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
    
    // 监测静默状态
    private func startSilentModeTimer() {
        if isSilentMode && !allPiggyBank.isEmpty {
            // 确保没有重复启动 Timer
            timerCancellable?.cancel()
            timerCancellable = nil
            
            timerCancellable = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { _ in
                    let elapsedTime = Date().timeIntervalSince(lastInteractionTime)
                    if elapsedTime > 10 {
                        print("elapsedTime:\(elapsedTime)")
                        DispatchQueue.main.async {
                            print("进入静默模式")
                            withAnimation(.easeInOut(duration: 1)) {
                                isSilentModeActive = true
                            }
                        }
                    } else if elapsedTime <= 10 {
                        print("elapsedTime:\(elapsedTime)")
                    }
                }
        }
    }
    
    
    // 处理 Sheet 或 Navigation 状态变化
    private func handleStateChange() {
        if isSilentMode {
            // 如果显示Sheet或者其他弹窗内容，暂停计时
            if isDisplaySettings || showDepositAndWithdrawView || showAccessRecordsView || showMoreInformationView || showManagingView || showDetailView || showStatistics {
                timerCancellable?.cancel()
                timerCancellable = nil
                print("暂停计时")
            } else {
                resetSilentMode() // 关闭后重置计时
                print("重置计时")
            }
        }
    }
    
    // 用户交互时重置静默模式
    private func resetSilentMode() {
        if isSilentMode {
            print("退出静默模式")
            lastInteractionTime = Date()
            withAnimation(.easeInOut(duration: 1)) {
                // 恢复按钮等视图的显示
                isSilentModeActive = false
            }
            startSilentModeTimer() // 重新启动计时
        }
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
    
    func saveWidgetData() {
        let userDefaults = UserDefaults(suiteName: "group.com.fangjunyu.piglet")
        // 存储存钱罐数据
            userDefaults?.set(piggyBank[0].icon, forKey: "piggyBankIcon")
            userDefaults?.set(piggyBank[0].name, forKey: "piggyBankName")
            userDefaults?.set(piggyBank[0].amount, forKey: "piggyBankAmount")
            userDefaults?.set(piggyBank[0].targetAmount, forKey: "piggyBankTargetAmount")
            userDefaults?.set(LoopAnimation, forKey: "LoopAnimation")
        userDefaults?.set(BackgroundImage, forKey: "background")
        
        
        // 然后手动触发 Widget 刷新
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            WidgetCenter.shared.reloadTimelines(ofKind: "BankletWidget")
            WidgetCenter.shared.reloadTimelines(ofKind: "BankletWidgetBackground")
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
                            Spacer().frame(height: height * 0.05)
                            // 顶部存钱罐左侧的图标
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
                                // 顶部存钱罐右侧储蓄信息
                                VStack(alignment: .leading) {
                                    Group {
                                        if piggyBank[0].amount == piggyBank[0].targetAmount {
                                            Text("Piggy bank full")
                                                .font(.title2)
                                                .fontWeight(.bold).animation(.easeInOut(duration: 0.5), value: difference)
                                        } else {
                                            Text("\(currencySymbolList.first{ $0.currencyAbbreviation == CurrencySymbol}?.currencySymbol ?? "$" )" + " " + "\(difference.formattedWithTwoDecimalPlaces())")
                                                .font(.title2)
                                                .fontWeight(.bold).animation(.easeInOut(duration: 0.5), value: difference)
                                        }
                                        Group {
                                            if  piggyBank[0].amount == piggyBank[0].targetAmount {
                                                Text("Completion date") + Text(piggyBank[0].completionDate,format: .dateTime.year().month().day())
                                            } else {
                                                Group {
                                                    Text("Distance")+Text(" \(piggyBank[0].name) ") + Text("Need")
                                                }
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.5)
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
                            .opacity(isSilentModeActive ? 0 : 1)
                            
                            Spacer().frame(height: isCompactScreen ? 0.02 : height * 0.08)
                            SpacedContainer(isCompactScreen: isCompactScreen) {
                                // 左侧详细信息和存钱记录
                                HStack {
                                    VStack(spacing: 0) {
                                        Group {
                                            // 显示详细信息的按钮
                                            Button(action: {
                                                withAnimation(.easeInOut(duration:0.5)) {
                                                    showDetailView.toggle()
                                                    //                                                    isTestDetails ? showDetailView.toggle() : isInfo.toggle()
                                                }
                                            }, label: {
                                                VStack {
                                                    // 图标修改为统计图标
                                                    //                                                    Image(systemName: isTestDetails ? "chart.pie" : piggyBank[0].icon)
                                                    Image(systemName: "chart.pie")
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
                                    
                                    // 隐藏1.0.5版本以前的左侧详细信息内容
                                    // 对话内容
                                    //                                    HStack(spacing: 0) {
                                    //                                        // 左边的三角
                                    //                                        LeftTriangle()
                                    //                                            .frame(width: 10,height:10)
                                    //                                            .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                    //                                        // 三角旁边的详细信息框
                                    //                                        VStack(alignment:.leading){
                                    //                                            Group {
                                    //                                                HStack(spacing:3) {
                                    //                                                    Text("Target amount")
                                    //                                                    Text(":")
                                    //                                                    Text("$ \(piggyBank[0].targetAmount.formattedWithTwoDecimalPlaces())")
                                    //                                                        .animation(.easeInOut(duration: 0.5), value: piggyBank[0].targetAmount)
                                    //                                                }
                                    //                                                HStack(spacing:3) {
                                    //                                                    Text("Current amount")
                                    //                                                    Text(":")
                                    //                                                    Text("$ \(piggyBank[0].amount.formattedWithTwoDecimalPlaces())")
                                    //                                                        .animation(.easeInOut(duration: 0.5), value: piggyBank[0].amount)
                                    //                                                }
                                    //                                                HStack(spacing:3) {
                                    //                                                    Text("Saving progress")
                                    //                                                    Text(":")
                                    //                                                    Text(LocalizedStringKey(savingsProgress))
                                    //                                                        .animation(.easeInOut(duration: 0.5), value: savingsProgress)
                                    //                                                }
                                    //                                            }
                                    //                                            .lineLimit(1)
                                    //                                            .minimumScaleFactor(0.3)
                                    //                                            .font(isCompactScreen ? .footnote : .body)
                                    //                                            .fontWeight(.bold)
                                    //                                            .fixedSize(horizontal: false, vertical: true) // 自动扩展宽度
                                    //                                        }
                                    //                                        .padding(.vertical,10)
                                    //                                        .padding(.horizontal,20)
                                    //                                        .foregroundColor(.white)
                                    //                                        .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                    //                                        .cornerRadius(10)
                                    //                                    }
                                    //                                    .offset(y: -30)
                                    //                                    .opacity(isInfo == true ? 1 : 0)
                                    Spacer()
                                }
                                .opacity(isSilentModeActive ? 0 : 1)
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
                                            .offset(x: isSilentModeActive ? width * -0.5 + 80 : 0,y: BackgroundImage == "Home0" ? -20 : 0)
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
                                            .opacity(isSilentModeActive ? 0 : 1)
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
                            .opacity(isSilentModeActive ? 0 : 1)
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
                    .onOpenURL { url in
                        // 测试深层链接
                        // 定义处理 Universal Link 的函数
                        print("Universal Link opened: \(url)")
                        // 如果 path = "/Settings"
                        if url.path == "/Settings" {
                            // 显示设置视图
                            isDisplaySettings.toggle()
                        }
                        
                    }
                    .sheet(isPresented: $showMoreInformationView, content: {
                        MoreInformationView()
                    })
                    .sheet(isPresented: $isDisplaySettings) {
                        Settings()
                    }
                    // 统计视图
                    .sheet(isPresented: $showStatistics) {
                        StatisticsView()
                            .presentationDetents([.height(500)])
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
                    //                    .onTapGesture {
                    //                        withAnimation(.easeInOut(duration:0.5)) {
                    //                            isInfo = false
                    //                        }
                    //                    }
                    .navigationTitle(isSilentModeActive ? "" : "Banklet")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        // 左上角 Menu 按钮
                        ToolbarItem(placement:.topBarLeading) {
                            
                            Menu(content: {
                                // 管理按钮
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
                                // 统计按钮
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 1)) {
                                        showStatistics.toggle()
                                    }
                                }, label: {
                                    HStack {
                                        Text("Statistics")
                                        Spacer()
                                        Image(systemName: "chart.xyaxis.line")
                                    }
                                })
                            }, label: {
                                Image(colorScheme == .light ? "iconWhite" : "iconWhiteDark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40)
                                    .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                            })
                            .opacity(isSilentModeActive ? 0 : 1)
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
                            .opacity(isSilentModeActive ? 0 : 1)
                        }
                    }
                    .frame(maxWidth:  geometry.size.width,maxHeight: geometry.size.height)
                    .background(
                        backgroundImageView()
                    )
                }
            }
        }
        .onAppear {
            if isSilentMode {
                startSilentModeTimer()
            }
        }
        .onDisappear {
            timerCancellable?.cancel()
            timerCancellable = nil // 确保页面消失时停止计时
            saveWidgetData()
        }
        .onTapGesture {
            if isSilentMode {
                resetSilentMode()
            }
        }
        .onChange(of: isDisplaySettings) { _,_ in
            if isSilentMode {
                handleStateChange()
            }
        }
        .onChange(of: showDepositAndWithdrawView) { _,_ in
            if isSilentMode {
                handleStateChange()
            }
        }
        .onChange(of: showAccessRecordsView) { _,_ in
            if isSilentMode {
                handleStateChange()
            }
        }
        .onChange(of: showMoreInformationView) { _,_ in
            if isSilentMode {
                handleStateChange()
            }
        }
        .onChange(of: showManagingView) { _,_ in
            if isSilentMode {
                handleStateChange()
            }
        }
        .onChange(of: showDetailView) { _,_ in
            if isSilentMode {
                handleStateChange()
            }
        }
        .onChange(of: showStatistics) { _,_ in
            if isSilentMode {
                handleStateChange()
            }
        }
    }
}
#Preview {
    @StateObject var iapManager = IAPManager.shared
    return Home()
        .modelContainer(PiggyBank.preview)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(iapManager)
        .environment(\.locale, .init(identifier: "ru"))
}
