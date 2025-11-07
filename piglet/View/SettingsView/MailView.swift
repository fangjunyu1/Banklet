//
//  MailView.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/7.
//

import SwiftUI
import DeviceKit
import MessageUI

struct MailView: View {
    @State private var mailResult: MFMailComposeResult?
    
    private let deviceInfo: String
    
    init() {
        let systemVersion = UIDevice.current.systemVersion
        let deviceModel = Device.current
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        
        self.deviceInfo = """
        ---
        Device: \(deviceModel)
        iOS Version: \(systemVersion)
        App Version: \(appVersion) (\(buildNumber))
        ---
        """
    }
    
    var body: some View {
        MailComposeViewController(
            recipients: ["fangjunyu.com@gmail.com"],
            subject: "Banklet Feedback",
            body: deviceInfo,
            resultCallback: { result in
                self.mailResult = result
            }
        )
    }
}

#Preview {
    MailView()
}
