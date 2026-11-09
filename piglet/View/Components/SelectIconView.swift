//
//  SelectIconView.swift
//  piglet
//
//  Created by 方君宇 on 2026/11/7.
//

import SwiftUI

struct SelectIconView:  View {
    @Binding var iconName: String
    let action: () -> Void
    let columns = [
        GridItem(.adaptive(minimum: 80, maximum: 120))
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 顶部标题
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Choose an Icon")
                        .font(.title2.bold())
                    
                    Text("Choose your favorite icon to decorate your piggy bank.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    action()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .frame(width: 32, height: 32)
                        .background(.gray.opacity(0.12))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 15)
            
            Divider()
            
            // 图标列表
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(IconList.list, id: \.self) { item in
                        Button {
                            iconName = item
                            action()
                        } label: {
                            OutlinedImageView(name: item)
                                .frame(maxWidth: 80, maxHeight: 80)
                                .padding(5)
                                .background {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            iconName == item
                                            ? Color.blue.opacity(0.1)
                                            : Color.clear
                                        )
                                }
                                .overlay {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(
                                            iconName == item
                                            ? Color.blue
                                            : Color.clear,
                                            lineWidth: 1.5
                                        )
                                }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    CreateView()
}
