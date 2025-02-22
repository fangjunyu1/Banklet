//
//  PiggyBank.swift
//  BankletWatch Watch App
//
//  Created by 方君宇 on 2025/2/21.
//
import SwiftUI

struct PiggyBank: Codable {
    var name: String
    var icon: String
    var amount: Double
    var targetAmount: Double
    var isPrimary: Bool
}
