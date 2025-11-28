//
//  GlobalTouchManager.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/28.
//

import SwiftUI

class GlobalTouchManager: NSObject, UIGestureRecognizerDelegate {
    static let shared = GlobalTouchManager()
    var onTouch: (() -> Void)?
    
    func setup() {
        guard let window = UIApplication.shared.windows.first else { return }
        let gesture = UITapGestureRecognizer()
        gesture.cancelsTouchesInView = false
        gesture.requiresExclusiveTouchType = false
        gesture.delegate = self
        window.addGestureRecognizer(gesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        onTouch?()
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
