//
//  AvatarImage.swift
//  SwiftSlim
//
//  Created by 方君宇 on 2026/6/3.
//

import SwiftUI
import Observation

@Observable
class AvatarImage: ObservableObject {
    static let shared = AvatarImage()   // 全局单例
    
    // 私有化对象
    private init() {}
    
    func loadAvatar(appStorage: AppStorageManager) async {
        let imageName = appStorage.userImageName
        
        let image = await loadAvatarImage(imageName: imageName)
        
        // 如果头像发生变化，或者任务被取消，退出加载头像函数
        await MainActor.run {
            if Task.isCancelled {
                return
            }
            appStorage.userImage = image
        }
    }
    
    func loadAvatarImage(imageName: String) async  -> UIImage? {
        
        let image: UIImage? = await Task.detached(priority: .utility) {
            
            // 1、先从 iCloud 获取头像文件
            if let data = try? iCloudFileManager.shared.read(fileName: "userProfileImage.jpg"), let image = UIImage(data: data) {
                print("从 iCloud 获取头像文件成功 ✅")
                return image
            }
            
            // 2、从本地获取头像文件
            guard !imageName.isEmpty else {
                print("无法从 iCloud 获取文件，本地保存的 imageName 为空，返回 nil")
                return nil
            }
            
            print("尝试从本地读取头像文件")
            
            // 每次读取时动态获取当前 Documents 路径
            let fileManager = FileManager.default
            let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docURL.appendingPathComponent(imageName)
            
            print("本地头像文件，读取路径：\(fileURL.path)")
            print("本地头像文件存在：\(fileManager.fileExists(atPath: fileURL.path))")
            
            if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
                print("从本地获取头像文件成功 ✅")
                return image
            }
            
            print("本地和 iCloud 都没有头像文件，返回 nil")
            return nil
        }.value
        
        return image
    }
    
}
