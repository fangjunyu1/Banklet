//
//  AccountSectionView.swift
//  piglet
//
//  Created by 方君宇 on 2026/6/3.
//

import SwiftUI

struct AccountSectionView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    @Environment(AppStorageManager.self) var appStorage
    
    var body: some View {
        NavigationLink(destination: {
            SettingsProfileView()
        }, label: {
            HStack(spacing: 20) {
                // 用户头像
                SettingsEnum.userImageView(displayName: appStorage.userDisplayName, image: appStorage.userImage, size: 68, fontSize: .title)
                
                VStack(alignment: .leading, spacing: 6) {
                    // 用户名称
                    Text(appStorage.userDisplayName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    if appStorage.isValidMember {
                        Text(verbatim: "PRO")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(Color("GoldColor"))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 10)
                            .background(Color.yellow.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay {
                                RoundedRectangle(cornerRadius: 5)
                                    .strokeBorder(Color.yellow, lineWidth: 1)
                            }
                            .frame(height: 18)
                        
                    } else {
                        Text("Free Account")
                            .font(.footnote)
                            .foregroundStyle(Color.gray)
                            .frame(height: 18)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Image("right")
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(.gray.opacity(0.8))
                    .opacity(0.5)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color("AppColor"))
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        })
    }
}

enum SettingsEnum {
    
    static var avatarGradient: some ShapeStyle {
        LinearGradient(
            colors: [Color.blue, Color.cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static func userImageView(displayName: String, image: UIImage?, size: CGFloat, fontSize: Font) -> some View {
        
        let trimmedName = displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        let initial = trimmedName.first.map(String.init) ?? "U"
        
        return VStack {
            if let img = image {
                Image(uiImage: img)
                    .resizable()
                    .scaledToFill()
            } else {
                Text(verbatim: String(initial.prefix(1)))
                    .font(fontSize)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(SettingsEnum.avatarGradient)
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
