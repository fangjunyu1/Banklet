//
//  BiometricAuthView.swift
//  piglet
//
//  Created by 方君宇 on 2025/1/15.
//

import LocalAuthentication

struct BiometricAuth {
    
    static let shared = BiometricAuth()
    
    private init() {}
    func authenticate(reason: String, completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        // 检查设备是否支持生物识别或设备密码验证
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {

            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true,nil)
                    } else {
                        let message = authenticationError?.localizedDescription ?? "Authentication failed"
                        completion(false, message)
                    }
                }
            }
        } else {
            // 设备不支持生物识别或密码验证
            DispatchQueue.main.async {
                    let message = error?.localizedDescription ?? "Biometric authentication is not available"
                    completion(false, message)
            }
        }
    }
}
