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
    var tab: ActivityTab = .LifePiggy
    
     func playMusicForCurrentTab(for tab: ActivityTab) {
       switch tab {
       case .LifePiggy:
           SoundManager.shared.playBackgroundMusic(named: "life0")
       case .LifeFund:
           SoundManager.shared.playBackgroundMusic(named: "life1")
       }
   }
}
