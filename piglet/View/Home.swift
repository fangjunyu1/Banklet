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
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @EnvironmentObject var sound: SoundManager  // 通过 Sound 注入
    @Query(sort: \PiggyBank.creationDate)   // 所有存钱罐，按创建日期排序
    var allPiggyBank: [PiggyBank]
    @Query(sort: \SavingsRecord.date)
    var savingsRecords: [SavingsRecord]  // 存取次数
    @State private var selectedTab = HomeTab.stats  // 当前选择的Tab
    @State private var searchText = ""  // 搜索框
    // 获取第一个存钱罐
    var primaryBank: PiggyBank? {
        allPiggyBank.filter { $0.isPrimary }.first
    }
    // 振动
    let generator = UISelectionFeedbackGenerator()
    ///
    /// if appStorage.isVibration {
    /// 发生振动
    /// generator.prepare()
    /// generator.selectionChanged()
    ///}
    ///
    
    
    @State var selectedTab1 = StatisticsTab.all
    var filteredBanks: [PiggyBank] {
        switch selectedTab1 {
        case .all:
            allPiggyBank
        case .inProgress:
            allPiggyBank.filter{ $0.progress < 1}
        case .completed:
            allPiggyBank.filter{ $0.progress == 1}
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Group {
                    // switch selectedTab
                    switch selectedTab {
                        // 主页视图
                    case .home:
                        HomeMainView(searchText: $searchText, allPiggyBank: allPiggyBank, primaryBank: primaryBank)
                        // 活动视图
                    case .activity:
                        HomeActivityView()
                        // 统计视图
                    case .stats:
                         // HomeStatsView()
                        ScrollView(showsIndicators: false) {
                            VStack(spacing: 20) {
                                // 1、统计顶部日期、存取次数、存款等信息
                                HStack(spacing:12) {
                                    // 日期图标、月份、周末
                                    VStack(alignment: .leading,spacing: 10) {
                                        let date = Date()
                                        let formattedData = date.formatted(
                                            Date.FormatStyle()
                                                .month(.wide)
                                                .day(.defaultDigits)
                                        )
                                        let formattedWeekday = date.formatted(
                                            Date.FormatStyle()
                                                .weekday(.abbreviated)
                                        )
                                        HStack(spacing: 10) {
                                            Image(systemName: "calendar")
                                                .foregroundColor(Color(hex: "DC6054"))
                                            Text("\(formattedData)")
                                                .font(.footnote)
                                        }
                                        Text("\(formattedWeekday)")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    // 分割线
                                    Divider().offset(x: 2)
                                    // 存取次数
                                    VStack(alignment: .leading,spacing: 10) {
                                        HStack(spacing: 10) {
                                            Image(systemName: "square.and.arrow.down.on.square.fill")
                                                .imageScale(.small)
                                                .foregroundColor(.gray)
                                            Text("\(savingsRecords.count)")
                                                .font(.footnote)
                                                .frame(minWidth: 40,alignment: .leading)
                                        }
                                        Text("Access times")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    // 分割线
                                    Divider().offset(x: 2)
                                    // 存款金额
                                    VStack(alignment: .leading,spacing: 10) {
                                        var savingRecordsCount: String {
                                            var count = 0.0
                                            for i in allPiggyBank {
                                                count += i.amount
                                            }
                                            return count.formattedWithTwoDecimalPlaces()
                                        }
                                        HStack(spacing: 10) {
                                            Text(currencySymbol)
                                                .foregroundColor(.gray)
                                            Text(savingRecordsCount)
                                                .font(.footnote)
                                        }
                                        Text("Deposit Amount")
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                // 2、全部、进行中、完成，三个切换进度
                                HStack {
                                    HStack(spacing:8) {
                                        // 列表（显示最多三个）
                                        ForEach(StatisticsTab.allCases, id:\.self) { item in
                                            Button(action: {
                                                withAnimation { selectedTab1 = item }
                                            }, label: {
                                                Text(LocalizedStringKey(item.title))
                                                    .font(.footnote)
                                                    .padding(.vertical, 12)
                                                    .padding(.horizontal, 20)
                                                    .frame(width: 80)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                                    .foregroundColor(selectedTab1 == item ? .black : .gray)
                                                    .cornerRadius(20)
                                            })
                                        }
                                    }
                                    .background {
                                        HStack {
                                            Rectangle()
                                                .frame(width:80,height:40)
                                                .foregroundColor(.white)
                                                .cornerRadius(20)
                                                .offset(x: CGFloat(selectedTab1.rawValue) * CGFloat(88))
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                }
                                // 3、存钱罐列表，最多显示三个
                                VStack {
                                    ForEach(Array(filteredBanks.prefix(3).enumerated()), id: \.offset) { index,item in
                                        // 每一个存钱罐的信息
                                        VStack {
                                            // 存钱罐标题、名称和金额
                                            HStack(spacing:10) {
                                                Image(systemName: item.icon)
                                                    .imageScale(.small)
                                                    .foregroundColor(AppColor.appGrayColor)
                                                Text(LocalizedStringKey(item.name))
                                                    .font(.footnote)
                                                    .foregroundColor(AppColor.appGrayColor)
                                                Spacer()
                                                Text(item.progressText)
                                                    .font(.footnote)
                                                    .foregroundColor(AppColor.bankList[index % AppColor.bankList.count])
                                            }
                                            // 存钱罐金额和进度方格
                                            HStack(alignment: .bottom) {
                                                Text(item.amountText)
                                                    .font(.footnote)
                                                    .foregroundColor(AppColor.appGrayColor)
                                                Spacer()
                                                // 进度方格
                                                VStack {
                                                    GridProgressView(rows: 4, columns: 10, progress: item.progress,filledColor:AppColor.bankList[index % AppColor.bankList.count])
                                                }
                                            }
                                        }
                                        .padding(20)
                                        .background(.white)
                                        .cornerRadius(10)
                                    }
                                }
                                // 4、存取次数，显示更多
                                HStack {
                                    Text("Access times")
                                        .fontWeight(.medium)
                                    Spacer()
                                    Button(action: {
                                        print("显示更多")
                                    }, label: {
                                        Text("Show more")
                                            .foregroundColor(AppColor.appColor)
                                            .font(.footnote)
                                    })
                                }
                                var recentRecords: [SavingsRecord] {
                                    Array(savingsRecords.prefix(3))
                                }
                                VStack {
                                    ForEach(recentRecords, id:\.self) { item in
                                        HStack(spacing: 15) {
                                            // 存钱罐图标
                                            ZStack {
                                                Circle()
                                                    .frame(width:35)
                                                    .foregroundColor(.blue.opacity(0.1))
                                                Image(systemName: item.piggyBank?.icon ?? "questionmark.circle")
                                                    .imageScale(.small)
                                                    .foregroundColor(.blue)
                                            }
                                            // 存钱罐名称和时间、金额
                                            VStack(spacing: 5) {
                                                // 奔驰车和金额
                                                HStack {
                                                    Text(LocalizedStringKey(item.piggyBank?.name ?? "Unknown"))
                                                        .font(.footnote)
                                                        .fontWeight(.medium)
                                                    Spacer()
                                                    Text(LocalizedStringKey(item.amountText))
                                                        .font(.system(size: 14))
                                                        .fontWeight(.medium)
                                                }
                                                // 存取时间、备注和存入/取出
                                                HStack {
                                                    let formattedDate = item.date.formatted(Date.FormatStyle().hour().minute())
                                                    Text(formattedDate)
                                                        .font(.caption2)
                                                        .foregroundColor(.gray)
                                                        Text(item.note ?? "")
                                                            .font(.caption2)
                                                    Spacer()
                                                    HStack(spacing:5) {
                                                        Image(systemName: item.saveMoney ? "arrowtriangle.down.fill" : "arrowtriangle.up.fill")
                                                        Text(item.saveMoney ? "Deposit" : "Withdraw")
                                                    }
                                                    .font(.caption2)
                                                    .foregroundColor(item.saveMoney ? AppColor.green : AppColor.red)
                                                }
                                            }
                                        }
                                        .frame(height:40)
                                        .padding(10)
                                        .background(.white)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        .navigationTitle("Stats")
                        .background {
                            AppColor.appBgGrayColor
                                .ignoresSafeArea()
                        }
                        .padding(20)
                        // 统计视图
                    case .settings:
                        HomeSettingsView()
                    }
                }
                // 液态玻璃 TabView 视图
                HomeTabView(selectedTab: $selectedTab)
            }
            .background {
                // 设置默认的背景灰色，防止各视图切换时显示白色闪烁背景
                AppColor.appBgGrayColor
                    .ignoresSafeArea()
            }
            // 监听应用状态，如果返回，则调用Widget保存数据
            .onChange(of: scenePhase) { _,newPhase in
                if newPhase == .active {
                    // App 进入活跃状态
                    print("App 进入活跃状态")
                }
                if newPhase == .background {
                    // 在应用进入后台时保存数据
                    saveWidgetData(primaryBank)
                    print("应用移入后台，调用Widget保存数据")
                }
                if newPhase == .inactive {
                    // 应用即将终止时保存数据（iOS 15+）
                    saveWidgetData(primaryBank)
                    print("非活跃状态，调用Widget保存数据")
                }
            }
        }
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
