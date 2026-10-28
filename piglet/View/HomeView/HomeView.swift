//
//  HomeView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//
//  默认水平边距为 20
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @EnvironmentObject var idleManager: IdleTimerManager
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(AppStorageManager.self) var appStorage
    @State private var showCreateView = false
    @State private var showMoreInformation = false
    
    let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 200)),
        GridItem(.adaptive(minimum: 160, maximum: 200))
    ]
    
    @Query(
        sort: [
            SortDescriptor(\PiggyBank.sortOrder),
            SortDescriptor(\PiggyBank.creationDate, order: .reverse)
        ]
    )
    var allPiggyBank: [PiggyBank]
    
    // 排序存钱罐列表
    private var sortedPiggyBanks: [PiggyBank] {
        allPiggyBank.sorted {
            if $0.pinnedSortOrder != $1.pinnedSortOrder {
                return $0.pinnedSortOrder < $1.pinnedSortOrder
            }

            if $0.sortOrder != $1.sortOrder {
                return $0.sortOrder < $1.sortOrder
            }

            return $0.creationDate > $1.creationDate
        }
    }
    
    // 搜索文本框
    @State var searchText: String = ""
    
    // 搜索存钱罐
    private var filteredPiggyBanks: [PiggyBank] {
        sortedPiggyBanks.filter {
            searchText.isEmpty ||
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // 创建存钱罐闭包
    let onCreatePiggyBank: () -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            // 如果有存钱罐
            if !allPiggyBank.isEmpty {
                // 搜索视图
                searchPiggyBankView
                // 所有存钱罐列表
                filterPiggyBankView
                Spacer()
            } else {
                // 显示空白视图
                emptyView
            }
            // 底部空白
            Spacer().frame(height: 50)
        }
        .navigationTitle("Piggy Bank")
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background {
            BackgroundImgView()
        }
        // 检查存钱罐的定期存款逻辑
        .onChange(of: scenePhase) { _, newValue in
            // 如果应用为活跃状态
            if newValue == .active {
                print("检查定期存款逻辑")
                SavingsScheduler.processAutoDeposits(context: context, piggyBank: allPiggyBank)
            }
        }
    }
    
    // 搜索栏视图
    private var searchPiggyBankView: some View {
        HStack {
            Image("search")
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .frame(width: 20)
                .foregroundStyle(AppColor.gray)
            TextField("search_piggy_banks", text: $searchText)
            if !searchText.isEmpty {
                Button(action: {
                    // 清理输入框内容
                    searchText = ""
                }, label: {
                    Image("close")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 20)
                        .foregroundStyle(AppColor.gray)
                })
            }
        }
        .padding(16)
        .background(Color("AppColor"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(20)
    }
    
    // 存钱罐列表
    private var filterPiggyBankView: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 30) {
            ForEach(filteredPiggyBanks, id:\.self) { piggyBank in
                VStack(spacing: 5) {
                    piggyBank.getImg
                        .resizable()
                        .scaledToFit()
                        .padding(.horizontal, 20)
                    OutlinedText(
                        text: piggyBank.name,
                        fontSize: 16,
                        fontWeight: .bold,
                        foregroundColor: .black,
                        strokeColor: .white,
                        strokeWidth: 10,
                        maxWidth: 160
                    )
                    Text(verbatim: piggyBank.progressText)
                        .fontWeight(.semibold)
                        .foregroundStyle(AppColor.gray)
                }
                .onTapGesture {
                    print("点击了视图")
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // 空存钱罐
    private var emptyView: some View {
        VStack {
            Spacer()
                .frame(height: 50)
            LottieView(filename: "EmptyBanklet", isPlaying: true, playCount: 0, isReversed: false)
                .scaledToFit()
                .scaleEffect(1.3)
                .frame(maxHeight: 180)
                .frame(maxWidth: 500)
            Spacer().frame(height: 30)
            // 文字内容
            VStack(spacing: 20) {
                // 标题
                Text("No piggy bank?")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                // 副标题
                Text("Let the piggy bank record your every growth and expectation.")
                    .font(.footnote)
                    .padding(.horizontal,30)
                    .modifier(GrayTextModifier())
                    .multilineTextAlignment(.center)
            }
            Spacer().frame(height: 50)
            Button(action:{
                // 振动
                HapticManager.shared.selectionChanged()
                // 创建存钱罐
                onCreatePiggyBank()
            },label: {
                Text("Create")
                    .modifier(ButtonModifier())
            })
            Spacer()
        }
    }
    // 存钱罐统计
//    private var staticView: some View {
//        HStack(spacing: 0) {
//            // 存钱罐数量
//            VStack(alignment: .leading, spacing: 6) {
//                Text("Piggy Bank")
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//
//                HStack(alignment: .firstTextBaseline, spacing: 4) {
//                    Text("\(allPiggyBank.count)")
//                        .font(.title2)
//                        .fontWeight(.semibold)
//
//                    Text("个")
//                        .font(.caption)
//                        .foregroundStyle(.secondary)
//                }
//            }
//
//            Spacer(minLength: 16)
//
//            // 累计存款
//            VStack(alignment: .trailing, spacing: 6) {
//                Text("Total Savings")
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
//
//                Text(
//                    "\(Currency.currencySymbol) \(allPiggyBank.reduce(0.0) { $0 + $1.amount }.formattedWithTwoDecimalPlaces())"
//                )
//                .font(.title2)
//                .fontWeight(.bold)
//                .contentTransition(.numericText())
//                .lineLimit(1)
//                .minimumScaleFactor(0.7)
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 18)
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .background {
//            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                .fill(.regularMaterial)
//        }
//        .padding(.top, 12)
//        .padding(.horizontal, 20)
//    }
    
}

#Preview {
    ContentView()
        .modelContainer(PiggyBank.preview)
        .environment(SoundManager.shared) // 加载音乐环境
        .environment(AppStorageManager.shared)    // 加载 UserDefaults 属性环境
        .environment(IAPManager.shared)    // 加载内购商品环境
        .environment(ModelConfigManager.shared)    // 加载 iCloud 配置环境
        .modelContainer(ModelContainerManager.shared.container)   // 加载 iCloud 容器环境
}
