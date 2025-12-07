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
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    @State private var isEdit = false
    @State private var draft:PiggyBankDraft
    @State private var showIcons = false
    @FocusState var isFocused: Bool
    
    init(primary: PiggyBank) {
        self.primary = primary
        _draft = State(initialValue: PiggyBankDraft(from: primary))
    }
    var primary: PiggyBank
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                CircularProgressView(primary: primary, size: 100,isEdit: isEdit, draft: $draft,showIcons: $showIcons)
                HomeMoreInfomationNameView(name: "Name",number: .string($draft.name,$isFocused),isEdit:isEdit)
                // 存钱罐图标列表
                HomeMoreInformationIconList(showIcons: showIcons,draft: $draft)
                // 存钱罐信息列表 1
                VStack(alignment: .leading) {
                    Footnote(text: "Piggy Bank Information")
                    // 存钱罐信息列表
                    HomeMoreInformationList1(primary:primary,draft: $draft,isEdit:isEdit,isFocused: $isFocused)
                }
                // 存钱罐信息列表 2
                if (primary.records != nil) {
                    VStack(alignment: .leading) {
                        Footnote(text: "Access times")
                        // 存钱罐信息列表
                        HomeMoreInformationList2(primary: primary, draft: $draft,isEdit:isEdit)
                    }
                }
            }
        }
        .onTapGesture {
            print("点击了背景")
            isFocused = false
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
            // 编辑视图
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    if isEdit {
                        draft.apply(to: primary, context: context)
                    }
                    withAnimation {
                        isEdit.toggle()
                        showIcons = false
                    }
                }, label: {
                    Text(isEdit ? "Finished Editing" : "Edit")
                        .foregroundColor(isEdit ? Color.blue : Color.primary)
                })
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

private struct HomeMoreInfomationNameView: View {
    var name: String
    var number: MoreInfomationEnum
    var isEdit: Bool
    var body: some View {
        if case .string(let binding,let focus) = number {
            TextField("",text: binding)
                .frame(alignment: .trailing)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .disabled(!isEdit)
                .focused(focus)
                .foregroundColor(isEdit ? Color.primary : Color.gray)
                .padding(10)
                .frame(maxWidth: 200)
                .background(Color.white)
                .cornerRadius(10)
        }
    }
}
private struct HomeMoreInformationList1: View {
    var primary: PiggyBank
    @Binding var draft: PiggyBankDraft
    var isEdit: Bool
    @FocusState.Binding var isFocused: Bool
    var body: some View {
        VStack {
            // 当前金额
            HomeMoreInformationList(name: "Current amount",number: .amount($draft.amount,$isFocused),isEdit:isEdit)
            Divider()
            // 初始金额
            HomeMoreInformationList(name: "Initial amount",number: .amount($draft.initialAmount,$isFocused),isEdit:isEdit)
            Divider()
            // 目标金额
            HomeMoreInformationList(name: "Target amount",number: .amount($draft.targetAmount,$isFocused),isEdit:isEdit)
            Divider()
            // 存取进度
            HomeMoreInformationList(name: "Access progress",number: .progress(draft.progressText),isEdit:isEdit)
            Divider()
            // 创建日期
            HomeMoreInformationList(name: "Creation Date",number: .date(draft.creationDate),isEdit:isEdit)
            // 完成日期
            if primary.progress >= 1 {
                Divider()
                HomeMoreInformationList(name: "Completion date",number: .date(draft.completionDate),isEdit:isEdit)
            }
            // 截止日期
            if primary.isExpirationDateEnabled {
                Divider()
                HomeMoreInformationList(name: "Expiration date",number: .date(draft.expirationDate),isEdit:isEdit)
            }
        }
        .padding(.vertical,5)
        .padding(.horizontal, 10)
        .background(Color.white)
        .cornerRadius(10)
    }
}

private struct HomeMoreInformationList2: View {
    @Query var records: [SavingsRecord]
    var primary: PiggyBank
    @Binding var draft: PiggyBankDraft
    var isEdit: Bool
    var lastDate: Date {
        primary.records?
            .sorted(by: {$0.date < $1.date})
            .last?
            .date ?? Date()
    }
    var body: some View {
        VStack {
            // 存取次数
            HomeMoreInformationList(name: "Access times",number: .record(Double(primary.records?.count ?? 0)), isEdit: isEdit)
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
    var isEdit: Bool
    var body: some View {
        HStack {
            Text(LocalizedStringKey(name))
            Spacer()
            switch number {
            case .string(let binding,let focus):
                TextField("",text: binding)
                    .frame(alignment: .trailing)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.trailing)
                    .disabled(!isEdit)
                    .focused(focus)
                    .foregroundColor(isEdit ? Color.primary : Color.gray)
            case .amount(let binding,let focus):
                TextField("",value: binding,format: .number)
                    .multilineTextAlignment(.trailing)
                    .disabled(!isEdit)
                    .focused(focus)
                    .foregroundColor(isEdit ? Color.primary : Color.gray)
                    .keyboardType(.decimalPad)
            case .progress(let string):
                Text(string)
                    .foregroundColor(Color.gray)
            case .date(let date):
                Text(date.formatted(date: .long,time: .omitted))
                    .foregroundColor(Color.gray)
            case .record(let double):
                Text("\(double.formatted())")
                    .foregroundColor(Color.gray)
            }
        }
        .padding(.vertical,5)
        .padding(.horizontal,10)
    }
}
struct HomeMoreInformationIconList: View {
    let columns = Array(repeating: GridItem(.fixed(30)), count: 3)
    var showIcons: Bool
    @Binding var draft: PiggyBankDraft
    var body: some View {
        if showIcons {
            VStack(alignment: .leading) {
                Footnote(text: "All icons")
                ScrollView(.horizontal,showsIndicators: false) {
                    LazyHGrid(rows: columns) {
                        ForEach(IconList.list, id: \.self) { item in
                            Button(action: {
                                draft.icon = item
                            }, label: {
                                Image(systemName: item)
                                    .foregroundColor(AppColor.gray)
                                    .imageScale(.large)
                                    .fontWeight(.bold)
                            })
                        }
                    }
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }
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
    case string(Binding<String>,FocusState<Bool>.Binding)
    case amount(Binding<Double>,FocusState<Bool>.Binding)
    case progress(String)
    case date(Date)
    case record(Double)
}

#Preview {
    PreviewMoreInformationView()
        .modelContainer(PiggyBank.preview)
        .environmentObject(IdleTimerManager.shared)
    //        .environment(\.locale, .init(identifier: "de"))
}
