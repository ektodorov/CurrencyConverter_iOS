//
//  ConversionRates.swift
//  CurrencyConverter
//

import Foundation

struct ConversionRates: Decodable {
    var result: String?
    var base_code: String?
    var conversion_rates: Dictionary<String, Float>?
}
