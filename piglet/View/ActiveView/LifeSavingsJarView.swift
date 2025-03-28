//
//  LifeSavingsJarView.swift
//  piglet
//
//  Created by 方君宇 on 2025/3/23.
//

import SwiftUI
import SwiftData

struct LifeSavingsJarView: View {
    @Environment(\.layoutDirection) var layoutDirection // 获取当前语言的文字方向
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    @Environment(\.modelContext) var modelContext
    @State private var age: Int? = nil  // 年龄
    @State private var annualSalary: Int? = nil //年薪
    @FocusState private var focusedField: Field? // 使用枚举管理焦点
    @State private var calculationProgress = false  // 计算进度条
    @State private var showLifePiggyBank = false
    @State private var LifePiggyBankAmount = 2000000  // 人生存钱罐金额
    @State private var creationCompleted = false    // 创建完成
    enum Field: Hashable {
        case ageField
        case annualSalaryField
    }
    
    func calculateLifePiggyBank() {
        var growthRate: Double = 0.05     // 薪资增长率 (如 0.05 表示 5%)
        var startingAge: Int = 18    // 起始年龄
        var startingSalary: Double = 0    // 起始年薪
        var retirementAge: Int = 65     // 预期退休年龄
        // 计算初始薪资
        if let age = age,let annualSalary = annualSalary,age >= startingAge{
            startingSalary = Double(annualSalary) / pow(1 + growthRate, Double(age - startingAge))
            print("起始年龄为:\(startingAge),初始薪资为：\(startingSalary)")
        } else {
            print("当前年龄无效，无法计算起始薪资！")
            return
        }
        // 累计未来收入
        var totalEarnings: Double = 0.0
        for i in startingAge..<retirementAge {
            print("第:\(i)岁，起始年薪为:\(startingSalary)")
            totalEarnings += startingSalary
            startingSalary *= Double(1) + growthRate  // 每年增长
        }
        
        // 转换为整数金额
        LifePiggyBankAmount = Int(totalEarnings)
        print("人生存钱罐的金额为:\(LifePiggyBankAmount)")
    }
    var body: some View {
        
        NavigationStack {
            GeometryReader { geometry in
                // 通过 `geometry` 获取布局信息
                let width = geometry.size.width * 0.85
                ZStack {
                    // 背景
                    Color(hex: colorScheme == .light ?  "f0f0f0" : "0E0E0E")
                        .ignoresSafeArea()
                    ScrollView(showsIndicators: false) {
                        Spacer().frame(height: 20)
                        Text("Use your lifetime salary income to plan your future")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 20)
                        Group {
                            Text("    ") + Text("Have you ever thought about how much wealth you can get from working for your entire life? The life piggy bank is designed for this purpose. From the beginning of your career to retirement, you can accumulate your lifetime income and make a comprehensive wealth plan for the future.")
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        Spacer().frame(height: 20)
                        Image("lifeImage0")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300)
                        
                        Spacer().frame(height: 20)
                        Text("Quickly calculate lifetime wealth")
                            .font(.title3)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        Spacer().frame(height: 20)
                        
                        Group {
                            Text("    ") + Text("Based on your current age and current salary, automatically calculate your career starting point, retirement age and salary growth rate, and calculate your lifetime income.")
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                        Spacer().frame(height: 20)
                        // 输入框
                        VStack {
                            // 年龄
                            HStack {
                                Text("Age")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer().frame(width: 20)
                                TextField("", value: $age, format: .number)
                                    .frame(width: 100)
                                    .foregroundColor(age == 0 ? .gray : colorScheme == .light ? .black : .white)
                                    .multilineTextAlignment(.center)
                                    .background {
                                        Rectangle().frame(width: .infinity,height: 4)
                                            .foregroundColor(.gray)
                                            .padding(.top)
                                            .offset(y: 10)
                                    }
                                    .keyboardType(.numberPad)
                                    .focused($focusedField,equals: .ageField)
                                // 对齐年薪的占位符
                                Text("\(currencySymbolList.first{ $0.currencyAbbreviation == appStorage.CurrencySymbol}?.currencySymbol ?? "$" )")
                                    .opacity(0)
                            }
                            Spacer().frame(height: 20)
                            // 年薪
                            HStack {
                                Text("Annual salary")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                Spacer().frame(width: 20)
                                TextField("", value: $annualSalary, format: .number)
                                    .frame(width: 100)
                                    .foregroundColor(annualSalary == 0 ? .gray : colorScheme == .light ? .black : .white)
                                    .multilineTextAlignment(.center)
                                    .background {
                                        Rectangle().frame(width: .infinity,height: 4)
                                            .foregroundColor(.gray)
                                            .padding(.top)
                                            .offset(y: 10)
                                    }
                                    .keyboardType(.numberPad)
                                    .focused($focusedField,equals: .annualSalaryField)
                                Spacer().frame(width: 10)
                                Text("\(currencySymbolList.first{ $0.currencyAbbreviation == appStorage.CurrencySymbol}?.currencySymbol ?? "$" )")
                            }
                        }
                        Spacer().frame(height: 30)
                        // 计算按钮
                        Button(action: {
                            calculationProgress = true
                            // 计算人生存钱罐
                            calculateLifePiggyBank()
                            // 模拟计算2秒钟
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                // 显示人生存钱罐
                                showLifePiggyBank = true
                                calculationProgress = false
                            }
                        }, label: {
                            VStack(alignment: .center) {
                                if calculationProgress {
                                    ProgressView("")
                                        .tint(.white)
                                        .offset(y:6)
                                } else {
                                    Text("Start calculation")
                                        .fontWeight(.bold)
                                }
                            }
                            .frame(width: 230, height: 66)
                            .foregroundColor(Color.white)
                            .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                            .cornerRadius(10)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        })
                        .shadow(radius: 4,y:4)
                        Spacer().frame(height:20)
                        Group {
                            Text("    ") +
                            Text("The default working age is 18, the annual salary requirement is greater than 10, the retirement age is 65, and the salary growth rate is 5%.")
                        }
                        .font(.footnote)
                        .foregroundColor(.gray)
                        Spacer().frame(height: 100)
                    }
                    .frame(width: width)
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .navigationTitle("Life savings jar")
                    .navigationBarTitleDisplayMode(.inline)
                    .onTapGesture {
                        // 取消文本输入框聚集
                        focusedField = nil
                    }
                    .overlay {
                        if showLifePiggyBank {
                            ZStack {
                                Color(.gray)
                                    .ignoresSafeArea()
                                    .opacity(0.3)
                                    .onTapGesture {
                                        // 处理点击灰色区域的逻辑
                                        showLifePiggyBank = false
                                    }
                                // 阻止触摸穿透
                                    .contentShape(Rectangle())
                                // 如果输入的内容正常
                                if let age = age, age >= 18 && age <= 65,let annualSalary = annualSalary, annualSalary > 10 && annualSalary < 100000000 {
                                    VStack {
                                        Text("Life savings jar")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(colorScheme == .light ? .black : Color(hex:"2C2B2D"))
                                        Spacer().frame(height:20)
                                        // 目标金额
                                        HStack {
                                            Text("Target amount")
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            Spacer().frame(width:20)
                                            // 人生存钱罐目标金额
                                            Group {
                                                Text("\(currencySymbolList.first{ $0.currencyAbbreviation == appStorage.CurrencySymbol}?.currencySymbol ?? "$" )")
                                                Spacer().frame(width:10)
                                                Text(LifePiggyBankAmount.formattedWithTwoDecimalPlaces())
                                            }
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            Spacer().frame(width:10)
                                        }
                                        Spacer().frame(height:20)
                                        Image("lifeImage1")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100)
                                        Spacer().frame(height:20)
                                        // 创建按钮
                                        if creationCompleted {
                                            Text("Congratulations, you have created it")
                                                .frame(width: 200,height:50)
                                                .foregroundColor(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                                .cornerRadius(10)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                        } else {
                                            Button(action: {
                                                // Step 1: 查询所有存钱罐
                                                let fetchRequest = FetchDescriptor<PiggyBank>()
                                                let existingPiggyBanks = try? modelContext.fetch(fetchRequest)
                                                
                                                // Step 2: 将所有存钱罐的 isPrimary 设置为 false
                                                existingPiggyBanks?.forEach { bank in
                                                    bank.isPrimary = false
                                                }
                                                // Step 3: 创建新的人生存钱罐并设置 isPrimary 为 true
                                                let piggyBank = PiggyBank(name: "Life savings jar",
                                                                          icon: "infinity",
                                                                          initialAmount:
                                                                            0,
                                                                          targetAmount: Double(LifePiggyBankAmount),
                                                                          amount:
                                                                            0,
                                                                          creationDate: Date(),
                                                                          expirationDate: Date(),
                                                                          isExpirationDateEnabled: false,
                                                                          isPrimary: true)
                                                modelContext.insert(piggyBank) // 将对象插入到上下文中
                                                do {
                                                    try modelContext.save() // 提交上下文中的所有更改
                                                } catch {
                                                    print("保存失败: \(error)")
                                                }
                                                creationCompleted = true    // 创建完成
                                            }, label: {
                                                Text("Create")
                                                    .frame(width: 200,height:50)
                                                    .foregroundColor(Color.white)
                                                    .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                                    .cornerRadius(10)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                                    .shadow(radius: 4,y: 4)
                                            })
                                        }
                                        
                                        // 取消按钮
                                        Button(action: {
                                            showLifePiggyBank = false
                                        }, label: {
                                            Text("Cancel")
                                                .frame(width: 200,height:50)
                                                .foregroundColor(Color.white)
                                                .background(.gray)
                                                .cornerRadius(10)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .shadow(radius: 4,y: 4)
                                        })
                                    }
                                    .padding(30)
                                    .frame(maxWidth: 320)
                                    .background(.white)
                                    .cornerRadius(10)
                                } else {
                                    // 输入的年龄和薪资有误
                                    VStack {
                                        Image("Error")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 200)
                                        Spacer().frame(height: 10)
                                        Text("The input information is incorrect")
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.black)
                                        Spacer().frame(height: 20)
                                        Button(action: {
                                            showLifePiggyBank = false
                                        }, label: {
                                            Text("OK")
                                                .padding(.vertical,10)
                                                .padding(.horizontal,40)
                                                .foregroundColor(Color.white)
                                                .background(colorScheme == .light ? Color(hex:"FF4B00") : Color(hex:"2C2B2D"))
                                                .cornerRadius(10)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .shadow(radius: 4,y: 4)
                                        })
                                    }
                                    .padding(30)
                                    .frame(maxWidth: 320)
                                    .background(.white)
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}


#Preview {
    LifeSavingsJarView()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
    //        .environment(\.locale, .init(identifier: "ru"))
}
