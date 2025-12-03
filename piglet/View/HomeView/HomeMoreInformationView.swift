//
//  MoreInformationView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/14.
//

import SwiftUI
import SwiftData

struct HomeMoreInformationView: View {
    @EnvironmentObject var idleManager: IdleTimerManager
    @Environment(\.dismiss) var dismiss
    var primary: PiggyBank
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                CircularProgressView(primary: primary, size: 100)
                // 存钱罐信息列表 1
                VStack(alignment: .leading) {
                    Footnote(text: "Piggy Bank Information")
                    // 存钱罐信息列表
                    HomeMoreInformationList1(primary: primary)
                }
                // 存钱罐信息列表 2
                if (primary.records != nil) {
                    VStack(alignment: .leading) {
                        Footnote(text: "Access times")
                        // 存钱罐信息列表
                        HomeMoreInformationList2(primary: primary)
                    }
                }
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top,20)
        .toolbar {
            // 完成视图
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Completed")
                })
                .tint(.black)
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background {
            AppColor.appBgGrayColor
                .ignoresSafeArea()
        }
        .onAppear {
            // 显示时，设置标志位为 true
            print("显示交易视图，关闭计时器")
            idleManager.isShowingIdleView = true
            idleManager.stopTimer()
        }
        .onDisappear {
            // 隐藏时，设置标志位为 false
            print("关闭交易视图，重启计时器")
            idleManager.isShowingIdleView = false
            idleManager.resetTimer()
        }
    }
}

private struct HomeMoreInformationList1: View {
    var primary: PiggyBank
    var body: some View {
        VStack {
            // 名称
            HomeMoreInformationList(name: "Name",number: .string(primary.name))
            Divider()
            // 当前金额
            HomeMoreInformationList(name: "Current amount",number: .string(primary.amountText))
            Divider()
            // 目标金额
            HomeMoreInformationList(name: "Target amount",number: .string(primary.targetAmountText))
            Divider()
            // 存取进度
            HomeMoreInformationList(name: "Access progress",number: .string(primary.progressText))
            Divider()
            // 创建日期
            HomeMoreInformationList(name: "Creation Date",number: .date(primary.creationDate))
            // 完成日期
            if primary.progress >= 1 {
                Divider()
                HomeMoreInformationList(name: "Completion date",number: .date(primary.completionDate))
            }
            // 截止日期
            if primary.isExpirationDateEnabled {
                Divider()
                HomeMoreInformationList(name: "Expiration date",number: .date(primary.expirationDate))
            }
        }
        .padding(.vertical,5)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
    }
}

private struct HomeMoreInformationList2: View {
    var primary: PiggyBank
    var lastDate: Date {
        primary.records?
            .sorted(by: {$0.date < $1.date})
            .last?
            .date ?? Date()
    }
    var body: some View {
        VStack {
            // 存取次数
            HomeMoreInformationList(name: "Access times",number: .amount(Double(primary.records?.count ?? 0)))
            Divider()
            // 最近一次存取日期
            HomeMoreInformationList(name: "Latest access date",number: .date(primary.records?.last?.date ?? Date()))
        }
        .padding(.vertical,5)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
    }
}
private struct HomeMoreInformationList: View {
    var name: String
    var number: MoreInfomationEnum
    var body: some View {
        HStack {
            Text(LocalizedStringKey(name))
            Spacer()
            switch number {
            case .string(let string):
                Text(LocalizedStringKey(string))
            case .amount(let amount):
                Text("\(amount.formatted())")
            case .progress(let double):
                Text("\(double.formatted())")
            case .date(let date):
                Text(date.formatted(date: .long,time: .omitted))
            }
        }
        .padding(.vertical,8)
        .padding(.horizontal,10)
    }
}

struct PreviewMoreInformationView: View {
    @Query var allPiggyBank: [PiggyBank]
    @State private var isSheet = true
    var primary: PiggyBank {
        return allPiggyBank.first(where: { $0.isPrimary}) ?? PiggyBank.PiggyBanks.first!
    }
    var body: some View {
        VStack {
            Text("Toggle")
                .onTapGesture {
                    isSheet.toggle()
                }
        }
        .sheet(isPresented: $isSheet) {
            NavigationStack {
                HomeMoreInformationView(primary: primary)
            }
        }
    }
}

private enum MoreInfomationEnum {
    case string(String)
    case amount(Double)
    case progress(Double)
    case date(Date)
}

#Preview {
    PreviewMoreInformationView()
        .modelContainer(PiggyBank.preview)
        .environmentObject(IdleTimerManager.shared)
    //        .environment(\.locale, .init(identifier: "de"))
}
