//
//  CreatePiggyBankPage2.swift
//  piglet
//
//  Created by 方君宇 on 2024/12/31.
//

import SwiftUI

struct CreatePiggyBankPage2: View {
    @Environment(AppStorageManager.self) var appStorage
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var icon: String? = "pencil.tip"
    @State private var Amount:String = ""
    @FocusState private var isFocus: Field? // 使用枚举管理焦点
    @State private var isOn: Bool = false   // 截止日期开关
    @State private var selectedDate = Date()
    @State private var isShowingDatePicker = false
    
    @Binding var pageSteps: Int
    @Binding var piggyBankData: PiggyBankData // 绑定 ContentView 中的 PiggyBankData
    
    let generator = UISelectionFeedbackGenerator()
    
    // 图标列表
    let iconArray: [String] = ["pencil.tip","books.vertical","graduationcap","dumbbell","soccerball","football","tennisball","trophy","location","camera","envelope","bag","creditcard","giftcard","briefcase","cross.case","suitcase.rolling","house","lightbulb.max","party.popper","popcorn","sofa","tent","mountain.2","building.2","map","laptopcomputer","iphone.gen2","ipad","visionpro","applewatch","headphones","airpodspro","beats.powerbeats","homepodmini","tv","airplane","car","tram","ferry","sailboat","bicycle","stroller","syringe","pills","dog","fish","teddybear","leaf","crown","tshirt","film","eye","photo","gamecontroller","birthday.cake","gift","list.bullet","dollarsign","apple.logo"]
    let rows = [
        GridItem(.adaptive(minimum: 30, maximum: 80), spacing: 0),
        GridItem(.adaptive(minimum: 30, maximum: 80), spacing: 0)
    ]
    
    enum Field: Hashable {
        case AmountField
    }
    var body: some View {
        
        GeometryReader { geometry in
            // 通过 `geometry` 获取布局信息
            let width = geometry.size.width * 0.85
            let height = geometry.size.height
            VStack {
                Spacer().frame(height:  height * 0.02)
                // 存钱罐进度条
                HStack {
                    Rectangle()
                        .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                        .frame(width: 130,height: 8)
                        .cornerRadius(10)
                        .clipShape(CreatingALeftProgressBar())
                    Rectangle()
                        .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                        .frame(width: 130,height: 8)
                        .cornerRadius(10)
                        .clipShape(CreatingARightProgressBar())
                    
                }
                Spacer().frame(height: height * 0.05)
                // 创建存钱罐
                Text("Create a piggy bank")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8) 
                Spacer().frame(height: height * 0.02)
                
                // 进一步完善存钱罐的信息。
                Text("Add more information to the piggy bank.")
                    .font(.footnote)
                    .foregroundColor(Color.gray)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Spacer().frame(height: 5)
                
                // 判断容器，紧凑视图为横屏
                SpacedContainer(isCompactScreen: true) {
                    Image(systemName: piggyBankData.icon == "" ? "shadow" : piggyBankData.icon)
                        .font(.largeTitle)
                        .imageScale(.large)
                        .frame(width: 60,height: 60)
                    
                    // 存钱罐图标
                    ScrollView(.horizontal,showsIndicators:false) {
                        LazyHGrid(rows: rows) {
                            ForEach(iconArray, id: \.self) { item in
                                Button(action: {
                                    if piggyBankData.icon != item {
                                        piggyBankData.icon = item
                                    } else {
                                        piggyBankData.icon = ""
                                    }
                                }, label: {
                                    Image(systemName: item)
                                        .font( .title)
                                        .foregroundColor(piggyBankData.icon == item ? .blue : .gray)
                                })
                                .frame(width: height * 0.08, height: height * 0.08)
                                .background(piggyBankData.icon == item ? Color.blue.opacity(0.2) : Color.clear)
                                .cornerRadius(10)
                            }
                        }
                        .padding(10)
                    }
                    .frame(height:  height * 0.15)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.gray, lineWidth: 1) // 设置边框颜色和宽度
                    )
                }
                // 选择存钱罐的图标。
                VStack(alignment: .leading) {
                    Text("Select the piggy bank icon.")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                Spacer().frame(height: height * 0.02)
                
                // 判断容器，紧凑视图为横屏
                SpacedContainer(isCompactScreen: true) {
                    Group {
                        // 设置存钱罐的初始金额
                        HStack {
                            Text("Initial amount")
                                .padding(.horizontal,20)
                            TextField("0.0", text: Binding(get: {
                                piggyBankData.amount == 0 ? "" : String(piggyBankData.amount.formattedWithTwoDecimalPlaces())
                            }, set: { newValue in
                                let userInput = parseInput(newValue)
                                piggyBankData.amount = userInput
                                piggyBankData.initialAmount = userInput
                            }))
                            .focused($isFocus, equals: .AmountField)
                            .keyboardType(.decimalPad)
                            .submitLabel(.continue)
                            .padding(.trailing,20)
                            
                        }
                        .frame(height:  height * 0.1)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1) // 设置边框颜色和宽度
                        )
                        
                        // 设定存钱罐已经存入的初始金额。
                        Spacer().frame(height: height * 0.01)
                        VStack(alignment: .leading) {
                            Text("Set the initial amount of money already deposited in the piggy bank.")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .frame(maxWidth: .infinity, alignment: .leading) // 让 VStack 占满宽度，并左对齐
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .frame(minHeight: 15)
                        }
                    }
                    Spacer().frame(width: 10, height: 10)
                    Group {
                        // 截止日期
                        HStack {
                            Text("Expiration date")
                                .padding(.horizontal,20)
                            Spacer()
                            // 截止日期
                            if isOn {
                                DatePicker("",
                                           selection: Binding(get: {
                                    piggyBankData.expirationDate
                                }, set: {
                                    piggyBankData.expirationDate = $0
                                }),
                                           displayedComponents: .date
                                )
                                .datePickerStyle(DefaultDatePickerStyle()) // 日期选择器样式
                                .frame(width: 80)
                                .offset(x: -10)                    .onTapGesture {
                                    isShowingDatePicker.toggle()
                                }
                                .sheet(isPresented: Binding(
                                    get: { isShowingDatePicker && horizontalSizeClass == .compact },
                                    set: { isShowingDatePicker = $0 }
                                )) {
                                    // iPhone 的行为
                                    VStack {
                                        HStack {
                                            Spacer()
                                            Button("closure") {
                                                isShowingDatePicker = false
                                            }
                                            .font(.callout)
                                            .foregroundColor(.blue)
                                            .padding(20)
                                            .offset(y:20)
                                        }
                                        DatePicker(
                                            "",
                                            selection: Binding(
                                                get: { piggyBankData.expirationDate },
                                                set: { piggyBankData.expirationDate = $0 }
                                            ),
                                            displayedComponents: .date
                                        )
                                        .datePickerStyle(WheelDatePickerStyle())
                                        .offset(x:-30)
                                        
                                    }
                                    .presentationDetents([.height(230)])
                                }
                                .popover(isPresented: Binding(
                                    get: { isShowingDatePicker && horizontalSizeClass != .compact },
                                    set: { isShowingDatePicker = $0 }
                                )) {
                                    VStack {
                                        DatePicker(
                                            "",
                                            selection: Binding(
                                                get: { piggyBankData.expirationDate },
                                                set: { piggyBankData.expirationDate = $0 }
                                            ),
                                            displayedComponents: .date
                                        )
                                        .datePickerStyle(WheelDatePickerStyle())
                                        .padding()
                                        Button("closure") {
                                            isShowingDatePicker = false
                                        }
                                    }
                                    .frame(width: 400, height: 300) // 自定义宽度和高度
                                }
                                
                            }
                            Spacer()
                            Toggle("", isOn: $isOn.animation(.easeInOut(duration: 1)))
                                .labelsHidden()
                                .padding(.horizontal,10)
                            
                        }
                        .frame(height: height * 0.1)
                        .cornerRadius(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.gray, lineWidth: 1) // 设置边框颜色和宽度
                        )
                        // 设定存钱罐的截止日期。
                        Spacer().frame(height: height * 0.01)
                        VStack(alignment: .leading) {
                            Text("Set the expiration date of the piggy bank.")
                                .font(.footnote)
                                .foregroundColor(Color.gray)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                                .frame(maxWidth: .infinity, alignment: .leading) // 让 VStack 占满宽度，并左对齐
                                .frame(minHeight: 15)
                        }
                        
                    }
                    
                }
                
                Spacer()
                Button(action: {
                    pageSteps = 3
                }, label: {
                    Text("Previous")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                })
                Spacer().frame(height: height * 0.02)
                Button(action: {
                    pageSteps = 5
                    piggyBankData.isExpirationDateEnabled = isOn
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
            .onTapGesture {
                isFocus = nil
            }
        }
    }
}

#Preview {
    CreatePiggyBankPage2(pageSteps: .constant(4),piggyBankData: .constant(PiggyBankData()))
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
