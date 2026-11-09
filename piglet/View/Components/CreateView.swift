//
//  CreateView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.colorScheme) var colorScheme
    // 临时创建存钱罐保存的数据
    @State private var piggyBank = PiggyBankData()
    // 是否完成
    @State private var isCompleted = false
    // 弹出图标 Sheet
    @State private var isShowIcon = false
    // 焦点
    @FocusState private var isNameFocus: Bool
    @FocusState private var isAmountFocus: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 创建存钱罐 - 标题
                createTitleView
                
                // 存钱罐图标
                createIconView
                
                VStack(spacing: 10) {
                    // 存钱罐名称
                    createNameView
                    // 存钱罐目标金额
                    createTargetAmountView
                    // 存钱罐初始金额
                }
                
                Spacer()
            }
            .padding(.horizontal,40)
            .padding(.top,30)
        }
        .navigationTitle("Create")
        .navigationBarTitleDisplayMode(.inline)
        .background {
            Background()
        }
        .onDisappear {
            print("退出视图时，重置信息状态")
            piggyBank = PiggyBankData()
            isCompleted = false
        }
        .sheet(isPresented: $isShowIcon) {
            SelectIconView(iconName: $piggyBank.icon) {
                isShowIcon.toggle()
            }
            .background {
                Background()
            }
        }
        .toolbar {
            if isAmountFocus {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Completed") {
                        isAmountFocus = false
                    }
                }
            }
        }
    }
    
    // MARK: 创建存钱罐 - 标题和副标题
    private var createTitleView: some View {
        HStack {
            VStack(alignment: .leading,spacing: 10) {
                Text(isCompleted ? "Creation completed" : "Create Piggy")
                    .font(.title2)
                    .fontWeight(.medium)
                Text(isCompleted ? "Your piggy bank has been created. You can now start adding savings and tracking your goal progress." : "Please fill in your savings plan information completely, and set the name, goal and starting amount step by step.")
                    .font(.footnote)
                    .foregroundColor(AppColor.gray)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: 存钱罐图标视图
    private var createIconView: some View {
        // 存钱罐贴纸
        OutlinedImageView(
            name: piggyBank.getImg
        )
        .frame(maxWidth: 120)
        .frame(maxHeight: 120)
        .shadow(color: colorScheme == .light ? .gray : .black.opacity(0.5), radius: 2, x:0, y: 3)
        .onTapGesture {
            isShowIcon.toggle()
        }
    }
    
    // MARK: 存钱罐名称视图
    private var createNameView: some View {
        var remainCharacters: Int {
            30 - piggyBank.name.count
        }
        
        return VStack {
            HStack(spacing: 16) {
                Text("Name")
                    .fontWeight(.medium)
                TextField("Set the name of the piggy bank", text: $piggyBank.name)
                    .font(.subheadline)
                    .focused($isNameFocus)
                    .minimumScaleFactor(0.5)
                    .onChange(of: piggyBank.name) {
                        if piggyBank.name.count > 30 {
                            piggyBank.name = String(piggyBank.name.prefix(30))
                        }
                    }
            }
            .modifier(CreateInputModifier())
            .transition(.move(edge: .top).combined(with: .opacity))
            
            HStack(spacing: 5) {
                Text("Remaining")
                Text(verbatim: "\(remainCharacters)")
                Text("Characters.")
                Spacer()
            }
            .font(.caption2)
            .foregroundColor(Color.gray)
            .fixedSize(horizontal: false, vertical: true)
            .offset(x: 10)
        }
    }
    
    // MARK: 存钱罐金额视图
    private var createTargetAmountView: some View {
        VStack {
            HStack(spacing: 15) {
                Text("Amount")
                    .fontWeight(.medium)
                TextField(value: $piggyBank.targetAmount, format: .number) {
                    Text(verbatim: "0")
                }
                .font(.subheadline)
                .focused($isAmountFocus)
                .keyboardType(.decimalPad)   // 数字 + 小数点键盘
            }
            .modifier(CreateInputModifier())
            .transition(.move(edge: .top).combined(with: .opacity))
            
            HStack {
                Text("Set a target amount for your piggy bank.")
                Spacer()
            }
            .font(.caption2)
            .foregroundColor(Color.gray)
            .fixedSize(horizontal: false, vertical: true)
            .offset(x: 10)
        }
    }
}

// 输入框样式
struct CreateInputModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(14)
            .frame(maxWidth: 400)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppColor.gray.opacity(0.3), lineWidth: 8)
                    .background(Color("defaultBackground"))
                    .cornerRadius(10)
            }
    }
}

#Preview {
    NavigationStack {
        CreateView()
    }
}
