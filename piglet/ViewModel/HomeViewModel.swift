//
//  HomeViewModel.swift
//  piglet
//
//  Created by 方君宇 on 2025/11/21.
//

import SwiftUI

@Observable
class HomeViewModel:ObservableObject {
    var isTradeView = false
    var tardeModel:TradeModel = .deposit
    var piggyBank: PiggyBank?
}


enum TradeModel {
    case deposit
    case withdraw
}
