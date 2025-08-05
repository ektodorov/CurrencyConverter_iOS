//
//  SupportedCurrencies.swift
//  CurrencyConverter
//

import Foundation

struct SupportedCurrencies: Decodable {
    var result: String?
    var supported_codes: Array<Array<String>>?
}
