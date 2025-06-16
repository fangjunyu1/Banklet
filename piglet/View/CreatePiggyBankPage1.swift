//
//  CreatePiggyBankPage1.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/31.
//

import SwiftUI
import SwiftData

struct CreatePiggyBankPage1: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @State private var showAlert = false
    @FocusState private var isFocus: Field? // 使用枚举管理焦点
    
    @Binding var pageSteps: Int
    @Binding var piggyBankData: PiggyBankData // 绑定 ContentView 中的 PiggyBankData
    
    let generator = UISelectionFeedbackGenerator()
    
    var limitLength: Int = 30
    var nameLength: Int {
        max(limitLength - piggyBankData.name.count,0)
    }
    
    // 判断输入的内容
    func DetermineInput() {
        if piggyBankData.name.isEmpty || piggyBankData.targetAmount == 0 {
            showAlert = true
        } else {
            pageSteps = 4
        }
    }
    
    enum Field: Hashable {
        case nameField
        case amountField
    }
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                let height = geometry.size.height
                VStack {
                    Spacer().frame(height: isLandscape ? height * 0.05 : height * 0.02)
                    // 存钱罐进度条
                    HStack {
                        Rectangle()
                            .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                            .frame(width: 130,height: 8)
                            .cornerRadius(10)
                            .clipShape(CreatingALeftProgressBar())
                        Rectangle()
                            .foregroundColor(.gray)
                            .frame(width: 130,height: 8)
                            .cornerRadius(10)
                            .clipShape(CreatingARightProgressBar())
                        
                    }
                    Spacer().frame(height: height * 0.05)
                    // 创建存钱罐
                    Text("Create a piggy bank")
                        .font(isCompactScreen ? .title : .largeTitle)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    
                    Spacer().frame(height: height * 0.01)
                    // 创建属于你的存钱罐。
                    Text("Create your own piggy bank.")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    Spacer().frame(height: height * 0.05)
                    Group {
                        // 设置存钱罐名称
                        HStack {
                            Text("Name")
                                .padding(.horizontal,20)
                            TextField("Set the name of the piggy bank", text: $piggyBankData.name)
                                .focused($isFocus, equals: .nameField)
                                .onChange(of: piggyBankData.name) { _,newValue in
                                    if newValue.count > limitLength {
                                        piggyBankData.name = String(newValue.prefix(limitLength))
                                    }
                                }
                                .padding(.trailing,20)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                        }
                        .frame(width: width,height: isCompactScreen ? 40 : 60)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1) // 设置边框颜色和宽度
                        )
                        VStack(alignment: .leading) {
                            HStack(spacing: 0) {
                                Group {
                                    Text("Remaining")
                                    Text(" \(nameLength) ")
                                    Text("Characters.")
                                }
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                                Spacer()
                            }
                        }
                        Spacer().frame(height: height * 0.02)
                        // 设置存钱罐金额
                        HStack {
                            Text("Amount")
                                .padding(.horizontal,20)
                            TextField("0.0", text: Binding(
                                get: { piggyBankData.targetAmount == 0 ? "" : String(piggyBankData.targetAmount.formattedWithTwoDecimalPlaces()) },
                                set: { newValue in
                                    let userInput = parseInput(newValue)
                                    piggyBankData.targetAmount = userInput
                                }
                            ))
                            .focused($isFocus, equals: .amountField)
                            .keyboardType(.decimalPad)
                            .submitLabel(.continue)
                            .padding(.trailing,20)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                            
                        }
                        .frame(width: width,height: isCompactScreen ? 40 : 60)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1) // 设置边框颜色和宽度
                        )
                        VStack(alignment: .leading) {
                            Text("Set the total amount you plan to deposit into your piggy bank.")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .leading) // 让 VStack 占满宽度，并左对齐
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                    }
                    if !isCompactScreen {
                        Spacer()
                        Image("CreateAPiggyBank1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: isLandscape ? width * 0.3 : width * 0.75)
                            .animation(.easeInOut(duration: 1), value: isFocus)
                            .opacity(colorScheme == .light ? 1 : 0.8)
                            .scaleEffect(x: layoutDirection == .leftToRight ? 1 : -1)
                        Text("Image by freepik")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    // 进入主界面
                    Button(action: {
                        pageSteps = 0
                    }, label: {
                        Text("Go directly to the main interface")
                            .font(.footnote)
                            .foregroundColor(Color.gray)
                    })
                    Spacer().frame(height: height * 0.02)
                    // 下一步
                    Button(action: {
                        DetermineInput()
                    }, label: {
                        Text("Next")
                            .frame(width: 320,height: 60)
                            .foregroundColor(Color.white)
                            .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                            .cornerRadius(10)
                    })
                    Spacer().frame(height: height * 0.05)
                }
                .frame(width: width)
                .frame(maxWidth: .infinity,maxHeight: .infinity)
                // 取消文本框的焦点
                .onTapGesture {
                    isFocus = nil
                }
                // 如果填写的字段为空，弹出警告框。
                .alert("Name or amount is missing", isPresented: $showAlert) {
                    Button("Confirm") {
                        pageSteps = 4
                    }
                    Button("Re-enter", role: .cancel) {
                        showAlert = false
                    }
                } message: {
                    Text("Are you sure you want to proceed?")
                }
            }
        }
    }
}

#Preview {
    CreatePiggyBankPage1(pageSteps: .constant(3),piggyBankData: .constant(PiggyBankData()))
        .modelContainer(PiggyBank.preview)
        .environment(\.locale, .init(identifier: "de"))   // 设置语言为阿拉伯语
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}

struct CreatingALeftProgressBar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX-5, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX-5, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
struct CreatingARightProgressBar: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX+5, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX+5, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
