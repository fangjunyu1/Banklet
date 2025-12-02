//
//  HomeActivityViewModel.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/19.
//

import SwiftUI

@Observable
@MainActor
final class HomeActivityViewModel: ObservableObject {
    var tab: ActivityTab = .LifeSavingsBank
    
     func playMusicForCurrentTab(for tab: ActivityTab) {
       switch tab {
       case .LifeSavingsBank:
           SoundManager.shared.playBackgroundMusic(named: "life0")
       case .EmergencyFund:
           SoundManager.shared.playBackgroundMusic(named: "life1")
       }
   }
}
