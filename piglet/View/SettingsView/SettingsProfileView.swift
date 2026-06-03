//
//  SettingsProfileView.swift
//  piglet
//
//  Created by 方君宇 on 2026/6/3.
//

import SwiftUI

private enum ProfileSaveError: Error {
    case imageEncodingFailed
}

enum SettingsSaveStats {
    case prepar
    case load
    case success
    case error
}

struct SettingsProfileView: View {
    @EnvironmentObject var appStorage: AppStorageManager
    @Environment(\.dismiss) var dismiss
    
    @State private var draftName = ""   // 临时保存的名称
    @State private var draftImage: UIImage? // 临时保存图片
    @State private var saveStats: SettingsSaveStats = .prepar
    @State private var isImagePickerPresented = false
    
    var body: some View {
        VStack(spacing: 30) {
            // 用户头像
            SettingsEnum.userImageView(displayName: draftName, image: draftImage, size: 100, fontSize: .system(size: 50))
                .onTapGesture {
                    isImagePickerPresented = true
                }
            // 用户名称
            userNameTextField
            // 提示信息
            userTip
            // 确认和取消按钮
            button
            Spacer()
        }
        .modifier(BackgroundModifier())
        .navigationTitle("profile card")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isImagePickerPresented) {
                ImagePickerViewController(selectedImage: $draftImage)
                    .ignoresSafeArea()
        }
        .onAppear {
            draftName = appStorage.userDisplayName
            draftImage = appStorage.userImage
        }
    }
    
    private var userNameTextField: some View {
        VStack(alignment: .leading) {
            Text("Name")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
            TextField(text: $draftName) {
                Text(verbatim: "")
            }
                .padding(.horizontal, 20)
                .frame(height: 50)
                .overlay {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(lineWidth: 0.5)
                        .opacity(0.3)
                }
                .padding(.horizontal, 10)
        }
    }
    private var userTip: some View {
        Text("ProfilTip")
            .font(.footnote)
            .foregroundStyle(Color.gray)
            .multilineTextAlignment(.center)
    }
    
    private var button: some View {
        VStack(spacing: 16) {
            Button(action: {
                // 触发振动
                HapticManager.shared.selectionChanged()
                
                Task {
                    await saveProfile()
                }
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .foregroundStyle(Color.blue)
                        .frame(width: 230, height: 55)
                    VStack {
                        if saveStats == .success {
                            Image(systemName: "checkmark")
                                .font(.system(size: 20).bold())
                        } else if saveStats == .prepar {
                            Text("save")
                                .fontWeight(.bold)
                        } else if saveStats == .error {
                            Image(systemName: "xmark")
                                .font(.system(size: 20).bold())
                        } else {
                            ProgressView()
                                .tint(.white)
                        }
                    }
                    .foregroundStyle(.white)
                }
            })
            .disabled(saveStats == .load)
            
            Button(action: {
                // 触发振动
                HapticManager.shared.selectionChanged()
                
                draftImage = appStorage.userImage
                dismiss()
            }, label: {
                Text("Cancel")
                    .font(.footnote)
                    .foregroundStyle(.gray)
            })
        }
    }
    
    // 保存个人简介
    @MainActor
    private func saveProfile() async {
        // 将保存动作改为加载中
        saveStats = .load
        
        // 保存临时名称和图片、图片文件名称
        let name = draftName
        let image = draftImage
        let fileName = "userProfileImage.jpg"  // 只保存文件名
        
        do {
            // 开始加载状态
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            
            // 保存图片文件
            try await saveAvatarFiles(image: image, fileName: fileName)
            print("保存个人资料成功")
            
            if appStorage.userName != name {
                appStorage.userName = name
            }
            
            if image != nil {
                appStorage.userImage = image
                appStorage.userImageName = fileName
            }
            
            // 恢复保存状态
            saveStats = .success
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            saveStats = .prepar
            
        } catch {
            print("保存个人资料失败：\(error.localizedDescription)")
            
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            saveStats = .error
            
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            saveStats = .prepar
        }
    }
    
    // 保存用户头像文件
    private func saveAvatarFiles(image: UIImage?,fileName: String) async throws {
        
        guard let image else {
            print("没有头像，仅保存用户名")
            return
        }
        
        // 1、保存本地文件
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            throw ProfileSaveError.imageEncodingFailed
        }
        
        try await saveAvatarToLocal(fileName: fileName, data: data)
        syncAvatarToiCloud(data: data, fileName: fileName)
    }
    
    // 将图片文件保存到本地
    private func saveAvatarToLocal(fileName: String, data: Data) async throws {
        try await Task.detached(priority: .utility) {
            let fileManager = FileManager.default
            let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docURL.appendingPathComponent(fileName)
            
            print("保存本地文件")
            try data.write(to: fileURL)
            print("本地文件保存成功：\(fileURL.path)")
        }.value
    }
    
    // 将图片文件保存到 iCloud
    private func syncAvatarToiCloud(data: Data, fileName: String) {
        Task.detached(priority: .utility) {
            do {
                print("保存 iCloud 文件")
                try iCloudFileManager.shared.save(
                    data: data,
                    fileName: fileName
                )
                
                await MainActor.run {
                    appStorage.avatarUpdatedUUID = UUID()
                }
                
                print("iCloud 文件保存成功")
            } catch {
                print("iCloud 文件保存失败")
            }
        }
    }
}
