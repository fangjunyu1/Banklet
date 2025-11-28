//
//  MailComposeViewController.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/7.
//

import SwiftUI
import MessageUI

struct MailComposeViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = MFMailComposeViewController
    
    var recipients: [String]
    var subject: String
    var body: String
    var resultCallback: ((MFMailComposeResult) -> Void)?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailComposeViewController
        
        init(parent: MailComposeViewController) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.resultCallback?(result)
            controller.dismiss(animated: true)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        vc.setSubject(subject)
        vc.setMessageBody(body, isHTML: false)
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
