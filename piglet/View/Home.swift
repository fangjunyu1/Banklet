//
//  Home.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/31.
//

import SwiftUI
import SwiftData
import Combine
import StoreKit
import WidgetKit

struct Home: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @EnvironmentObject var sound: SoundManager  // 通过 Sound 注入
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
    @State private var showActivity = false // 显示活动视图
    @State private var selectedTab = 0  // 当前选择的Tab
    
    // Tab元组
    let tabs = [
        ("house.fill", "Home"),
        ("flag.fill", "Activity"),
        ("chart.pie.fill", "Stats"),
        ("gearshape.fill", "Settings")
    ]
    
    
    let generator = UISelectionFeedbackGenerator()
    
    let maxHistorySize = 3 // 历史记录长度
    
    var difference: Double {
        let differenceNum = piggyBank[0].targetAmount - piggyBank[0].amount
        return differenceNum > 0 ? differenceNum : 0.0
    }
    
    var progress: Double {
        let progressNum =  piggyBank[0].amount / piggyBank[0].targetAmount
        return progressNum
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
        if !appStorage.BackgroundImage.isEmpty {
            Image(appStorage.BackgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .brightness(colorScheme == .dark ? -0.5 : 0) // 让深色模式降低亮度
        } else {
            EmptyView()
        }
    }
    
    var body: some View {
        ZStack {
            // 测试-显示一个模糊的背景
            VStack {
                Image("bg0")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
            
            //            NavigationStack {
            //                VStack {
            //                    //  存钱罐显示内容
            //                    if piggyBank.count != 0 {
            //                        ZStack {
            //                            ScrollView(showsIndicators: false) {
            //                                VStack {
            //                                    Spacer().frame(height: 15)
            //                                    // 顶部存钱罐信息
            //                                    HStack(spacing: 0) {
            //                                        // 如果 Swich切换状态为 true，显示进度条和差额。
            //                                        if appStorage.SwitchTopStyle {
            //                                            ZStack {
            //                                                // 外圈进度条
            //                                                CircularProgressBar(progress: progress)
            //                                                    .frame(width: 40)
            //                                                Circle().fill(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
            //                                                    .frame(width: 40)
            //                                                    .overlay {
            //                                                        Image(systemName: piggyBank[0].icon)
            //                                                            .font(.title3)
            //                                                            .foregroundColor(.white)
            //                                                    }
            //                                                    .padding(.horizontal,10)
            //                                                    .contentShape(Circle())
            //                                                    .onTapGesture {
            //                                                        showMoreInformationView.toggle()
            //                                                    }
            //                                                    .contextMenu {
            //                                                        Button(action: {
            //                                                            showMoreInformationView.toggle()
            //                                                        }, label: {
            //                                                            Label("Details",systemImage:"list.clipboard")
            //                                                        })
            //                                                    }
            //                                            }
            //                                            Spacer().frame(width: 10)
            //                                            // 如果 Swich切换状态为 false，仅显示存入金额。
            //                                            VStack(alignment: .leading) {
            //                                                Group {
            //                                                    if piggyBank[0].amount == piggyBank[0].targetAmount {
            //                                                        Text("Piggy bank full")
            //                                                            .font(.title2)
            //                                                            .fontWeight(.bold).animation(.easeInOut(duration: 0.5), value: difference)
            //                                                    } else {
            //                                                        Text("\(currencySymbolList.first{ $0.currencyAbbreviation == appStorage.CurrencySymbol}?.currencySymbol ?? "$" )" + " " + "\(difference.formattedWithTwoDecimalPlaces())")
            //                                                            .font(.title2)
            //                                                            .fontWeight(.bold).animation(.easeInOut(duration: 0.5), value: difference)
            //                                                    }
            //                                                    Group {
            //                                                        if  piggyBank[0].amount == piggyBank[0].targetAmount {
            //                                                            Text("Completion date") + Text(piggyBank[0].completionDate,format: .dateTime.year().month().day())
            //                                                        } else {
            //                                                            HStack {
            //                                                                Text("\(NSLocalizedString("Distance", comment: "距离"))  \(NSLocalizedString(piggyBank[0].name, comment: ""))  \(NSLocalizedString("Need", comment: "还需要"))")
            //                                                            }
            //                                                            .lineLimit(2)
            //                                                            .minimumScaleFactor(0.5)
            //                                                        }
            //                                                    }
            //                                                    .font(.footnote)
            //                                                    .fontWeight(.bold)
            //                                                    .lineLimit(1)
            //                                                    .minimumScaleFactor(0.8)
            //                                                }
            //                                                .foregroundColor(.white)
            //                                                .frame(maxWidth: .infinity,alignment: .leading)
            //                                                .lineLimit(2)
            //                                                .minimumScaleFactor(0.8)
            //                                            }
            //                                        } else {
            //                                            // 如果 Swich切换状态为 false，仅显示存入金额。
            //                                            ZStack {
            //                                                VStack {
            //                                                    HStack {
            //                                                        Image(systemName: piggyBank[0].icon)
            //                                                            .font(.largeTitle)
            //                                                            .foregroundColor(.white)
            //                                                            .opacity(0.6)
            //                                                        Spacer()
            //                                                    }
            //                                                }
            //                                                VStack {
            //                                                    if piggyBank[0].amount == piggyBank[0].targetAmount {
            //                                                        Text("Piggy bank full")
            //                                                            .font(.system(size: 30))
            //                                                            .fontWeight(.bold).animation(.easeInOut(duration: 0.5), value: difference)
            //                                                    } else {
            //                                                        Text("\(currencySymbolList.first{ $0.currencyAbbreviation == appStorage.CurrencySymbol}?.currencySymbol ?? "$" )" + " " + "\(piggyBank[0].amount.formattedWithTwoDecimalPlaces())")
            //                                                            .font(.system(size: 33))
            //                                                            .scaleEffect(0.9)
            //                                                            .fontWeight(.bold).animation(.easeInOut(duration: 0.5), value: difference)
            //                                                    }
            //                                                    Group {
            //                                                        if  piggyBank[0].amount == piggyBank[0].targetAmount {
            //                                                            Text("Completion date") + Text(piggyBank[0].completionDate,format: .dateTime.year().month().day())
            //                                                        } else {
            //                                                            HStack {
            //                                                                Text("\(NSLocalizedString(piggyBank[0].name, comment: "存钱罐名称"))  \(NSLocalizedString("Deposited", comment: "距离"))")
            //                                                            }
            //                                                            .lineLimit(2)
            //                                                            .minimumScaleFactor(0.5)
            //                                                        }
            //                                                    }
            //                                                    .font(.footnote)
            //                                                    .fontWeight(.bold)
            //                                                    .lineLimit(1)
            //                                                    .minimumScaleFactor(0.8)
            //                                                }
            //                                                .foregroundColor(.white)
            //                                                .frame(maxWidth: .infinity)
            //                                                .lineLimit(2)
            //                                                .minimumScaleFactor(0.8)
            //                                            }
            //                                        }
            //                                    }
            //                                    .padding(10)
            //                                    .frame(height:80)
            //                                    .background(
            //                                        RoundedRectangle(cornerRadius: 10)
            //                                            .fill(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
            //                                            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                                    )
            //                                    .cornerRadius(10)
            //                                    .onTapGesture {
            //                                        if appStorage.isVibration {
            //                                            // 发生振动
            //                                            generator.prepare()
            //                                            generator.selectionChanged()
            //                                        }
            //
            //                                        appStorage.SwitchTopStyle.toggle()
            //                                    }
            //
            //                                    Spacer().frame(height:  10)
            //                                    // 左侧详细信息和存钱记录
            //                                    HStack {
            //                                        VStack(spacing: 0) {
            //                                            Group {
            //                                                // 显示详细信息的按钮
            //                                                Button(action: {
            //                                                    print("BUtton查看详情按钮")
            //                                                    withAnimation(.easeInOut(duration:0.5)) {
            //                                                        showDetailView.toggle()
            //                                                    }
            //                                                }, label: {
            //                                                    VStack {
            //                                                        Image(systemName: "chart.pie")
            //                                                            .resizable()
            //                                                            .scaledToFit()
            //                                                            .frame(width:20, height: 20)
            //                                                    }
            //                                                    .frame(width: 40, height: 40)
            //                                                })
            //                                                .onTapGesture {
            //                                                    print("点击了查看详情按钮")
            //                                                }
            //                                                Rectangle()
            //                                                    .fill(.white)
            //                                                    .frame(width: 30, height: 1) // 自定义宽度和高度
            //
            //                                                // 显示存取记录的按钮
            //                                                Button(action: {
            //                                                    showAccessRecordsView.toggle()
            //                                                }, label: {
            //                                                    VStack {
            //                                                        Image(systemName: "clock.arrow.circlepath")
            //                                                            .resizable()
            //                                                            .scaledToFit()
            //                                                            .frame(width: 20,height: 20)
            //                                                    }
            //                                                    .frame(width: 40, height: 40)
            //                                                })
            //                                            }
            //                                        }
            //                                        .frame(width: 40,height: 81)
            //                                        .foregroundColor(.white)
            //                                        .background(
            //                                            RoundedRectangle(cornerRadius: 10)
            //                                                .fill(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
            //                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                                        )
            //                                        .cornerRadius(10)
            //                                        Spacer()
            //                                    }
            //                                    Spacer().frame(width: 0,height: 10)
            //                                }
            //                                // 存取猪猪动画
            //                                HStack {
            //                                    // 谚语
            //                                    if isDisplayedProverb {
            //                                        // 谚语
            //                                        Spacer()
            //                                        VStack {
            //                                            HStack(spacing: 0) {
            //                                                Group {
            //                                                    Text(LocalizedStringKey(currentProverb))
            //                                                        .padding(10)
            //                                                        .foregroundColor(.white)
            //                                                        .background(
            //                                                            RoundedRectangle(cornerRadius: 10)
            //                                                                .fill(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
            //                                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                                                        )
            //                                                        .cornerRadius(10)
            //                                                        .fixedSize(horizontal: false, vertical: true) // 自动扩展宽度
            //                                                        .lineLimit(7)
            //                                                        .minimumScaleFactor(0.6)
            //                                                    RightTriangle()
            //                                                        .frame(width: 10,height:10)
            //                                                        .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
            //                                                }
            //                                            }
            //                                        }
            //                                        .frame(maxWidth: 300,maxHeight: 50)
            //                                    } else {
            //                                        Spacer()
            //                                    }
            //                                    VStack {
            //                                        // 存钱猪猪动画
            //                                        LottieView(filename: appStorage.LoopAnimation,isPlaying: appStorage.isLoopAnimation ? true : isPlaying, playCount: appStorage.isLoopAnimation ? 0 : 1, isReversed: appStorage.isLoopAnimation ? false : isReversed)
            //                                            .id(appStorage.LoopAnimation) // 关键：确保当 LoopAnimation 变化时，LottieView 重新加载
            //                                            .scaleEffect(x: layoutDirection == .leftToRight ? AnimationScaleConfig.scale(for: "\(appStorage.LoopAnimation)") : -AnimationScaleConfig.scale(for: "\(appStorage.LoopAnimation)"), y: AnimationScaleConfig.scale(for: "\(appStorage.LoopAnimation)")) // 水平翻转视图
            //                                            .opacity(colorScheme == .light ? 1 : 0.8)
            //                                            .disabled(isProverb)
            //                                            .frame(width: 160, height: 160)
            //                                            .contentShape(Circle())
            //                                            .onTapGesture {
            //                                                print("点击了存钱猪猪动画，并触发震动")
            //                                                if appStorage.isVibration {
            //                                                    // 发生振动
            //                                                    generator.prepare()
            //                                                    generator.selectionChanged()
            //                                                }
            //                                                print("点击了动画")
            //                                                // 点击动画时刷新谚语
            //                                                currentProverb = generateUniqueRandomProverb()
            //                                                withAnimation(.easeInOut(duration: 0.5)) {
            //                                                    isDisplayedProverb = true
            //                                                    isProverb = false
            //                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //                                                        isDisplayedProverb = false
            //                                                        isProverb = true
            //                                                    }
            //                                                }
            //
            //                                                // 新增点击次数统计，用于激活评分
            //                                                print("RatingClicks:\(appStorage.RatingClicks)")
            //                                                appStorage.RatingClicks += 1
            //                                                if appStorage.RatingClicks == 2 {
            //                                                    print("调用获取评分请求")
            //                                                    SKStoreReviewController.requestReview()
            //                                                }
            //                                            }
            //                                            .allowsHitTesting(isProverb)
            //
            //                                        // 存钱罐日期
            //                                        if piggyBank[0].isExpirationDateEnabled {
            //                                            HStack{
            //                                                Group {
            //                                                    Image(systemName: "calendar")
            //                                                    Spacer().frame(width: 10)
            //                                                    Text(piggyBank[0].expirationDate,format: .dateTime.year().month().day())
            //                                                        .fixedSize(horizontal: true, vertical: false) // 自动扩展宽度
            //                                                }
            //                                                .font(.footnote)
            //                                                .foregroundColor(.gray)
            //                                            }
            //                                        }
            //                                    }
            //                                }
            //                                Spacer()
            //                                // 存入取出按钮
            //                                Button(action: {
            //                                    // 打开存取视图
            //                                    print("点击了存入/取出按钮")
            //                                    showDepositAndWithdrawView.toggle()
            //                                }, label: {
            //                                    Text("Deposit/withdraw")
            //                                        .frame(width: 320,height: 60)
            //                                        .foregroundColor(Color.white)
            //                                        .background(
            //                                            RoundedRectangle(cornerRadius: 10)
            //                                                .fill(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
            //                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                                        )
            //                                        .cornerRadius(10)
            //                                })
            //                                // 底部留白为50高度
            //                                Spacer().frame(height: 10)
            //                            }
            //                            .frame(height: 600)
            //                        }
            //                    }  else {
            //                        // 空白占位符
            //                        Spacer()
            //                        Group {
            //                            Image("empty")
            //                                .resizable()
            //                                .scaledToFit()
            //                            Spacer().frame(height: 20)
            //                            Text("Image by freepik")
            //                                .font(.footnote)
            //                                .foregroundColor(.gray)
            //                                .frame(maxWidth: .infinity, alignment: .trailing)
            //                                .offset(y: -20)
            //                        }
            //                        // 未创建存钱罐提示
            //                        Group {
            //                            Text("You haven't created it yet")
            //                            Text("Piggy Bank")
            //                        }
            //                        .font(.largeTitle)
            //                        .fontWeight(.black)
            //                        .multilineTextAlignment(.center)
            //
            //                        Spacer().frame(height: 20)
            //                        Text("Let the piggy bank record your every growth and expectation.")
            //                            .font(.footnote)
            //                            .foregroundColor(.gray)
            //                            .multilineTextAlignment(.center)
            //                        Spacer()
            //                        Button(action: {
            //                            // 跳转到创建视图
            //                            appStorage.pageSteps = 3
            //                        }, label: {
            //                            Text("Create")
            //                                .frame(width: 320,height: 60)
            //                                .foregroundColor(Color.white)
            //                                .background(
            //                                    RoundedRectangle(cornerRadius: 10)
            //                                        .fill(Color(hex:"FF4B00"))
            //                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
            //                                )
            //                                .cornerRadius(10)
            //                        })
            //                    }
            //                }
            //                .onOpenURL { url in
            //                    // 测试深层链接
            //                    // 定义处理 Universal Link 的函数
            //                    print("Universal Link opened: \(url)")
            //                    // 如果 path = "/Settings"
            //                    if url.path == "/Settings" {
            //                        // 显示设置视图
            //                        isDisplaySettings.toggle()
            //                    }
            //
            //                }
            //                .sheet(isPresented: $showMoreInformationView, content: {
            //                    MoreInformationView()
            //                })
            //                .sheet(isPresented: $isDisplaySettings) {
            //                    Settings()
            //                }
            //                // 统计视图
            //                .sheet(isPresented: $showStatistics) {
            //                    StatisticsView()
            //                }
            //                .sheet(isPresented: $showAccessRecordsView) {
            //                    AccessRecordsView(piggyBank: piggyBank[0])
            //                }
            //                // 管理视图
            //                .sheet(isPresented: $showManagingView, content: {
            //                    ManagingView()
            //                        .presentationDetents([.height(260)])
            //                })
            //
            //                // 详细信息（缩略）视图
            //                .sheet(isPresented: $showDetailView, content: {
            //                    DetailView(CurrentAmount: piggyBank[0].amount, TargetAmount: piggyBank[0].targetAmount)
            //                        .presentationDetents([.height(300)])
            //                })
            //                .sheet(isPresented: $showDepositAndWithdrawView, content: {
            //                    DepositAndWithdrawView(isReversed: $isReversed) {
            //                        // 回调闭包，执行存钱动画
            //                        isPlaying = true
            //                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            //                            isPlaying = false
            //                        }
            //                        // 如果启用音效，则调用存钱音效
            //                        if appStorage.isSoundEffects {
            //                            sound.playSound(named: "money")
            //                        }
            //                    }
            //                })
            //                .sheet(isPresented: $showActivity, content: {
            //                    ActivityView()
            //                })
            //                .background(
            //                    backgroundImageView()
            //                )
            //                .navigationTitle("Banklet")
            //                .navigationBarTitleDisplayMode(.inline)
            //                .toolbar {
            //                    // 左上角 Menu 按钮
            //                    ToolbarItem(placement:.topBarLeading) {
            //
            //                        Menu(content: {
            //                            // 管理按钮
            //                            Button(action: {
            //                                withAnimation(.easeInOut(duration: 1)) {
            //                                    showManagingView.toggle()
            //                                }
            //                            }, label: {
            //                                HStack {
            //                                    Text("Manage")
            //                                    Spacer()
            //                                    Image(systemName: "pin")
            //                                }
            //                            })
            //                            // 统计按钮
            //                            Button(action: {
            //                                withAnimation(.easeInOut(duration: 1)) {
            //                                    showStatistics.toggle()
            //                                }
            //                            }, label: {
            //                                HStack {
            //                                    Text("Statistics")
            //                                    Spacer()
            //                                    Image(systemName: "chart.xyaxis.line")
            //                                }
            //                            })
            //                            if appStorage.isShowActivity {
            //                                // 活动入口
            //                                Button(action: {
            //                                    withAnimation(.easeInOut(duration: 1)) {
            //                                        showActivity.toggle()
            //                                    }
            //                                }, label: {
            //                                    HStack {
            //                                        Text("Activity")
            //                                        Spacer()
            //                                        Image(systemName: "flag")
            //                                    }
            //                                })
            //                            }
            //                        }, label: {
            //                            Image(colorScheme == .light ? "iconWhite" : "iconWhiteDark")
            //                                .resizable()
            //                                .scaledToFit()
            //                                .frame(width: 40)
            //                                .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
            //                        })
            //                    }
            //                    // 右上角设置按钮
            //                    ToolbarItem(placement: .topBarTrailing) {
            //                        Button(action: {
            //                            isDisplaySettings.toggle()
            //                        }, label: {
            //                            Image(systemName: "gearshape")
            //                                .resizable()
            //                                .scaledToFit()
            //                                .foregroundColor(colorScheme == .light ? .black : .white)
            //                        })
            //                    }
            //                }
            //                .onChange(of: scenePhase) { _,newPhase in
            //                    if newPhase == .active {
            //                        // App 进入活跃状态
            //                        print("App 进入活跃状态")
            //                    }
            //                    if newPhase == .background {
            //                        // 在应用进入后台时保存数据
            //                        saveWidgetData(allPiggyBank)
            //                        print("应用移入后台，调用Widget保存数据")
            //                    }
            //                    if newPhase == .inactive {
            //                        // 应用即将终止时保存数据（iOS 15+）
            //                        saveWidgetData(allPiggyBank)
            //                        print("非活跃状态，调用Widget保存数据")
            //                    }
            //                }
            //            }
            
            Text("\(selectedTab)").font(.title)
            Spacer().frame(height:20)
            // 液态玻璃 TabView
            
            VStack {
                Spacer()
                HStack(spacing: 50) {
                    ForEach(tabs.indices, id: \.self) { index in
                        let (image, tab) = tabs[index]
                        SingleTabView(HomeImage: image, HomeText: tab,index: index, selectedTab: $selectedTab)
                    }
                }
                .padding(.vertical,12)
                .padding(.horizontal,30)
                .background(
                    HStack {
                        Rectangle()
                            .fill(.white)
                            .frame(width: 80,height: 60)
                            .cornerRadius(40)
                            .offset(x:5)
                            .offset(x: CGFloat(75) * CGFloat(selectedTab))
                        
                        Spacer()
                    }
                )
                .background(
                    Rectangle()
                        .fill(.regularMaterial)
                        .blur(radius: 3)
                        .cornerRadius(100)
                        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
                )
            }
        }
    }
}

struct SingleTabView: View {
    var HomeImage: String
    var HomeText:String
    var index: Int
    @Binding var selectedTab: Int
    @State private var clicked = false
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: HomeImage)
                .imageScale(.large)
                .symbolEffect(.bounce, value: clicked)
                .foregroundColor(selectedTab == index ? .blue : .gray)
            Text(LocalizedStringKey(HomeText))
                .textScale(.secondary)
                .foregroundColor(selectedTab == index ? .blue : .gray)
        }
        .foregroundColor(AppColor.gray)
        .onTapGesture {
            clicked.toggle()
            withAnimation{ selectedTab = index } // 设置当前的索引
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
    // .environment(\.locale, .init(identifier: "ru"))
}
