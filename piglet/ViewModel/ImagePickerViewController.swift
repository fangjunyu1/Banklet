//
//  ImagePickerViewController.swift
//  piglet
//
//  Created by 方君宇 on 2026/6/3.
//

import SwiftUI
import UIKit

// 封装 UIImagePickerController
struct ImagePickerViewController: UIViewControllerRepresentable {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePickerViewController

        init(parent: ImagePickerViewController) {
            self.parent = parent
        }

        // 处理图片选择
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        // 处理取消选择
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    @Binding var selectedImage: UIImage?
    
    // 创建 UIImagePickerController 实例
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.delegate = context.coordinator
        pickerController.sourceType = .photoLibrary  // 设置照片库作为来源
        return pickerController
    }
    
    // 更新 UIViewController（不需要在此做任何事）
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    // 创建协调器
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
}
