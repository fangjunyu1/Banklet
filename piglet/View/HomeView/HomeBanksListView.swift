//
//  HomeBanksListView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/1.
//

import SwiftUI

struct HomeBanksListView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var homeVM: HomeViewModel
    var allPiggyBank: [PiggyBank]
    
    var body: some View {
        VStack {
            // 存钱罐列表和显示更多
            HStack {
                Footnote(text: "list of piggy banks")
                Spacer()
                NavigationLink(destination: HomeBanksListView2()) {
                    Text("Show more")
                        .font(.footnote)
                        .modifier(BlueTextModifier())
                }
                .simultaneousGesture(TapGesture().onEnded {
                    HapticManager.shared.selectionChanged()
                })
            }
            // 存钱罐列表
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(allPiggyBank.enumerated()), id: \.offset) { index,item in
                        let itemColor: Color = item.isPrimary ? .white : .primary
                        var itemBgColor: Color {
                            if colorScheme == .light {
                                item.isPrimary ? .white.opacity(0.25) : AppColor.bankList[index % AppColor.bankList.count]
                            } else {
                                item.isPrimary ?
                                AppColor.appColor.opacity(0.8) :
                                    .white.opacity(0.25)
                            }
                        }
                        var itemProgressColor: Color {
                            if colorScheme == .light {
                                item.isPrimary ? .white : AppColor.bankList[index % AppColor.bankList.count]
                            } else {
                                item.isPrimary ? .white : .gray
                            }
                        }
                        let itemProgressBgColor: Color = item.isPrimary ? AppColor.appBgGrayColor.opacity(0.5) : AppColor.gray.opacity(0.5)
                        var vsBgColor: Color {
                            if colorScheme == .light {
                                item.isPrimary ? .blue : Color.white
                            } else {
                                item.isPrimary ? AppColor.appGrayColor : Color.black
                            }
                        }
                        Button(action: {
                            // 振动
                            HapticManager.shared.selectionChanged()
                            // 选择该存钱罐为主存钱罐
                            homeVM.setPiggyBank(for: item)
                        }, label: {
                            VStack {
                                HStack {
                                    // 我的存钱罐图标
                                    Image(systemName:item.icon)
                                        .imageScale(.small)
                                        .foregroundColor(.white)
                                        .background {
                                            Circle()
                                                .foregroundColor(itemBgColor)
                                                .frame(width: 35, height: 35)
                                        }
                                        .frame(width: 35, height: 35)
                                    Spacer()
                                    // 我的存钱罐进度
                                    Text(item.progressText)
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .foregroundColor(itemColor)
                                        .minimumScaleFactor(0.5)
                                }
                                Spacer()
                                
                                // 我的存钱罐名称
                                HStack {
                                    Text(LocalizedStringKey(item.name))
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .foregroundColor(itemColor)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                    Spacer()
                                }
                                // 进度条
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .foregroundColor(itemProgressBgColor)
                                        .frame(height:10)
                                        .cornerRadius(5)
                                    Rectangle()
                                            .foregroundColor(itemProgressColor)
                                            .frame(width: min(item.progress * 116,116),height:10)
                                            .cornerRadius(5)
                                }
                            }
                        })
                        .contentShape(Rectangle())
                        .padding(12)
                        .frame(width:140,height: 120)
                        .background(vsBgColor)
                        .cornerRadius(10)
                    }
                }
            }
        }
        .padding(.top,10)
    }
}

#Preview {
    Home()
        .modelContainer(PiggyBank.preview)
        .environment(AppStorageManager.shared)
        .environment(ModelConfigManager()) // 提供 ModelConfigManager 实例
        .environmentObject(IAPManager.shared)
        .environmentObject(SoundManager.shared)
}
