//
//  Currency.swift
//  CurrencyConverter
//

import Foundation

struct Currency : Identifiable, Equatable, Hashable {
    var id: UUID = UUID()
    var currencyAbbreviation: String = ""
    var currencyName: String = ""
    var rate: Float = 0.0
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(currencyAbbreviation)
        hasher.combine(currencyName)
    }
}
