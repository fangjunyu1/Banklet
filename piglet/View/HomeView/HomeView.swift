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

// 存钱罐进度分类
enum ProgressStatusTab: Int, CaseIterable {
    case all
    case active
    case done
    
    var title: String {
        switch self {
        case .all: return "all"
        case .active: return "active"
        case .done: return "done"
        }
    }
}

struct HomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var context
    @EnvironmentObject var idleManager: IdleTimerManager
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(AppStorageManager.self) var appStorage
    @State private var showCreateView = false
    @State private var showMoreInformation = false
    @State private var selectedTab: ProgressStatusTab = .all
    @State private var hiddenAmount = false
    @State private var selectedDeleteItem: PiggyBank? = nil
    
    let columns = [
        GridItem(.adaptive(minimum: 160, maximum: 200)),
        GridItem(.adaptive(minimum: 160, maximum: 200))
    ]
    
    @Query
    var allPiggyBank: [PiggyBank]
    
    // 排序存钱罐列表
    private var sortedPiggyBanks: [PiggyBank] {
        allPiggyBank.sorted {
            if $0.pinnedSortOrder != $1.pinnedSortOrder {
                return $0.pinnedSortOrder > $1.pinnedSortOrder
            }
            
            if $0.sortOrder != $1.sortOrder {
                return $0.sortOrder > $1.sortOrder
            }
            
            return $0.creationDate > $1.creationDate
        }
    }
    
    // 搜索文本框
    @State var searchText: String = ""
    
    // 搜索存钱罐
    private var filteredPiggyBanks: [PiggyBank] {
        let filtered = switch selectedTab {
        case .all:
            sortedPiggyBanks
        case .active:
            sortedPiggyBanks.filter {
                $0.progressStatus == .active
            }
        case .done:
            sortedPiggyBanks.filter {
                $0.progressStatus == .done
            }
        }
        
        return filtered.filter {
            searchText.isEmpty ||
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // 存钱罐总数
    private var totalPiggyBankCount: Int {
        allPiggyBank.count
    }
    
    // 存入总金额
    private var totalAmount: Double {
        allPiggyBank.reduce(0) { $0 + $1.amount }
    }
    
    // 存钱罐数量
    var piggyBankCounts: [ProgressStatusTab: Int] {
        var counts: [ProgressStatusTab: Int] = [
            .all: allPiggyBank.count,
            .active: 0,
            .done: 0
        ]
        
        for piggyBank in allPiggyBank {
            switch piggyBank.progressStatus {
            case .all:
                break
            case .active:
                counts[.active, default: 0] += 1
            case .done:
                counts[.done, default: 0] += 1
            }
        }
        
        return counts
    }
    
    // 创建存钱罐闭包
    let onCreatePiggyBank: () -> Void
    
    var body: some View {
        ZStack {
            // 固定背景，不参与 ScrollView 的滚动
            BackgroundImgView()
            
            // 可滚动内容
            ScrollView(showsIndicators: false) {
                // 如果有存钱罐
                if !allPiggyBank.isEmpty {
                    VStack(spacing: 16) {
                        // 存钱概览视图
                        savingsOverviewView
                        // 搜索视图
                        searchPiggyBankView
                        // 标签按钮
                        progressStatusTabView
                    }
                    // 所有存钱罐列表
                    filterPiggyBankView
                    
                    // 底部空白
                    Spacer().frame(height: 185)
                } else {
                    // 显示空白视图
                    emptyView
                }
            }
        }
        .navigationTitle("Piggy Bank")
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .sheet(item: $selectedDeleteItem) { item in
            HomeDeleteSheet(item: $selectedDeleteItem)
                .presentationDetents([.height(300), .height(350)])
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
    
    // 存款概览
    private var savingsOverviewView: some View {
        HStack(spacing: 6) {
            Text("Piggy Bank")
                .foregroundStyle(AppColor.gray)
            
            Text("\(totalPiggyBankCount)")
                .fontWeight(.semibold)
            
            Spacer(minLength: 12)
            
            Text("Deposit Amount")
                .foregroundStyle(AppColor.gray)
            
            Text(
                Currency.currencySymbol + " "
                + (hiddenAmount ? "* * * *" : totalAmount.formattedWithTwoDecimalPlaces())
            )
            .fontWeight(.semibold)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
            .onTapGesture {
                hiddenAmount.toggle()
            }
        }
        .font(.subheadline)
        .padding(.horizontal, 20)
        .padding(.top, 16)
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
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color("defaultBackground"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
    }
    
    // 存钱罐进度 Tab 视图
    private var progressStatusTabView: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(ProgressStatusTab.allCases, id: \.rawValue) { tab in
                    let isSelected = selectedTab == tab
                    Button(action: {
                        selectedTab = tab
                    }, label: {
                        HStack {
                            Text(LocalizedStringKey(tab.title))
                            Text("\(piggyBankCounts[tab] ?? 0)")
                        }
                        .font(.subheadline)
                        .foregroundStyle(isSelected ? .defaultBackground : .inverseBackground)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(isSelected ? .inverseBackground : .defaultBackground)
                        .cornerRadius(20)
                    })
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    // 存钱罐列表
    private var filterPiggyBankView: some View {
        LazyVGrid(columns: columns, alignment: .center, spacing: 30) {
            ForEach(filteredPiggyBanks, id: \.persistentModelID) { piggyBank in
                PiggyBankCard(piggyBank: piggyBank) {
                    selectedDeleteItem = piggyBank
                }
            }
        }
    }
    
    // 存钱罐卡片
    private struct PiggyBankCard: View {
        @Environment(\.modelContext) var context
        let piggyBank: PiggyBank
        let onDelete: () -> Void
        
        var body: some View {
            VStack(spacing: 2) {
                // 存满后显示
                if piggyBank.progress >= 1 {
                    HStack {
                        Text(verbatim: "已完成")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 14)
                            .foregroundStyle(AppColor.green)
                            .background(Color("defaultBackground"))
                            .cornerRadius(16)
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
                
                piggyBank.getImg
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 150)
                
                HStack {
                    OutlinedText(
                        text: piggyBank.name,
                        fontSize: 16,
                        fontWeight: .bold,
                        foregroundColor: .black,
                        strokeColor: .white,
                        strokeWidth: 10,
                        maxWidth: 160
                    )
                    .offset(x: piggyBank.isPinned ? -10 : 0)
                    .overlay(alignment: .trailing) {
                        if piggyBank.isPinned {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(.gray)
                                .frame(width: 30, height: 30)
                                .offset(x: 10)
                        }
                    }
                }
                
                // 存钱进度，存满则不显示
                if piggyBank.progress <= 1 {
                    Text(verbatim: piggyBank.progressText)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundStyle(AppColor.gray)
                }
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 20)
            .contextMenu {
                Button {
                    piggyBank.isPinned.toggle()
                    try? context.save()
                } label: {
                    Label(
                        piggyBank.isPinned ? "unpin" : "pin",
                        systemImage: piggyBank.isPinned ? "pin.slash" : "pin"
                    )
                }
                
                Button(role: .destructive) {
                    // 删除逻辑
                    onDelete()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
        }
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

// 删除存钱罐视图
private struct HomeDeleteSheet: View {
    @Environment(\.modelContext) var context
    @Binding var item: PiggyBank?
    var body: some View {
        VStack {
            VStack(spacing: 24) {
                // 删除存钱罐标题和关闭图标
                HStack {
                    // 删除存钱罐
                    Text("Delete Piggy Bank")
                        .modifier(Title2Modifier())
                    
                    Spacer()
                    
                    // 关闭视图
                    Button(action: {
                        item = nil
                    }, label: {
                        Image("close1")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 20)
                            .foregroundStyle(AppColor.gray)
                    })
                }
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
                
                // 存钱罐信息
                HStack {
                    item?.getImg
                        .resizable()
                        .scaledToFit()
                        .frame(height: 80)
                    VStack {
                        OutlinedText(
                            text: item?.name ?? "None",
                            fontSize: 16,
                            fontWeight: .bold,
                            foregroundColor: .black,
                            strokeColor: .white,
                            strokeWidth: 10,
                            maxWidth: 100
                        )
                        Text(verbatim: item?.progressText ?? "0")
                            .fontWeight(.semibold)
                            .font(.subheadline)
                            .foregroundStyle(AppColor.gray)
                    }
                }
                .padding(.horizontal, 20)
                
                // 存钱罐删除注释
                Text(
                    String(
                        format: NSLocalizedString(
                            "delete_piggy_bank_warning",
                            comment: ""
                        ),
                        item?.records?.count ?? 0
                    )
                )
                .modifier(FootNoteModifier1())
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 20)
            }
            Spacer()
            
            // 取消和删除按钮
            HStack {
                // 取消按钮
                Button(action: {
                    print("取消删除操作")
                    item = nil
                }, label: {
                    Text("Cancel")
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 10)
                        .frame(width: 140, height: 50)
                        .foregroundStyle(Color.inverseBackground)
                        .background(Color.defaultBackground)
                        .cornerRadius(16)
                })
                
                Spacer()
                    .frame(width: 20)
                
                Button(role: .destructive) {
                    guard let item else { return }
                    
                    context.delete(item)
                    self.item = nil
                    
                    do {
                        try context.save()
                        print("删除成功")
                    } catch {
                        print("删除存钱罐失败：\(error)")
                    }
                } label: {
                    Text("Delete")
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .padding(.horizontal, 10)
                        .frame(width: 140, height: 50)
                        .foregroundStyle(.white)
                        .background(.red)
                        .cornerRadius(16)
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(.top, 30)
    }
}

// 存钱概览
//    private var savingsOverviewView: some View {
//        HStack(spacing: 0) {
//            // 存钱罐数量
//            VStack(alignment: .leading, spacing: 8) {
//                Text(verbatim: "存钱罐数量")
//                    .font(.subheadline)
//                    .foregroundStyle(AppColor.gray)
//
//                Text("\(totalPiggyBankCount)")
//                    .font(.title2.bold())
//                    .foregroundStyle(.primary)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//
//            Rectangle()
//                .fill(AppColor.gray.opacity(0.2))
//                .frame(width: 1, height: 42)
//
//            // 存入总金额
//            VStack(alignment: .leading, spacing: 8) {
//                Text(verbatim: "存入总金额")
//                    .font(.subheadline)
//                    .foregroundStyle(AppColor.gray)
//
//                Text(Currency.currencySymbol + " " + totalAmount.formattedWithTwoDecimalPlaces())
//                .font(.title2.bold())
//                .foregroundStyle(.primary)
//                .lineLimit(1)
//                .minimumScaleFactor(0.75)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(.leading, 20)
//        }
//        .padding(20)
//        .background(Color("defaultBackground"))
//        .clipShape(RoundedRectangle(cornerRadius: 16))
//        .padding(.horizontal, 20)
//    }


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
