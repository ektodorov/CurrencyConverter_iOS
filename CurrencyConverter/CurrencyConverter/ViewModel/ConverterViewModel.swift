//
//  ConverterViewModel.swift
//  CurrencyConverter
//

import Foundation

class ConverterViewModel: ObservableObject {
    
    @Published var listSupportedCurrencies: Array<Currency> = Array<Currency>()
    @Published var allConversions: Array<String> = Array<String>()
    @Published var conversionRates: ConversionRates = ConversionRates()
    @Published var ammount: String = ""
    @Published var isLoading: Bool = true
    @Published var convertFromIndex: Int = 0
    @Published var convertToIndex: Int = 1
    private var currencyApi: CurrencyApi?
    
    func getCurrencyList() {
        isLoading = true
        if(currencyApi == nil) {
            currencyApi = CurrencyApi()
        }
        currencyApi?.supportedCurrencies {[weak self] list in
            self?.listSupportedCurrencies.removeAll()
            self?.listSupportedCurrencies.append(contentsOf: list)
        }
        isLoading = false
    }
    
    func getCurrencyListAsync() async {
        Task {@MainActor [weak self] in
            self?.isLoading = true
        }
        
        if(currencyApi == nil) {
            currencyApi = CurrencyApi()
        }
        let list: Array<Currency> = await currencyApi!.supportedCurrenciesAsync()
        Task {@MainActor [weak self] in
            self?.listSupportedCurrencies.removeAll()
            self?.listSupportedCurrencies.append(contentsOf: list)
            self?.isLoading = false
        }
        await MainActor.run {
            
        }
        Task {
            
        }
    }
    
    func getConversionRates(currency: String) {
        isLoading = true
        if(currencyApi == nil) {
            currencyApi = CurrencyApi()
        }
        currencyApi?.conversions(forCurrency: currency) {[weak self] conversionRates in
            if(self == nil) {
                return
            }
            self!.conversionRates = conversionRates
        }
        isLoading = false
    }
    
    func getConversionRatesAsync(currency: String) async {
        Task {@MainActor [weak self] in
            self?.isLoading = true
        }
        if(currencyApi == nil) {
            currencyApi = CurrencyApi()
        }
        if let rates: ConversionRates = await currencyApi!.conversionsAsync(forCurrency: currency) {
            Task {@MainActor [weak self] in
                self?.conversionRates = rates
            }
        }
        Task {@MainActor [weak self] in
            self?.isLoading = false
        }
    }
    
    func convert(ammount: String, reverse: Bool) -> Float {
        let ammountNumber: Float = Float(ammount) ?? 0.0
        let toAbbreviation = self.listSupportedCurrencies[self.convertToIndex].currencyAbbreviation
        let rateTo: Float = self.conversionRates.conversion_rates![toAbbreviation] ?? 0.0
        if(reverse) {
            let result: Float = ammountNumber / rateTo
            return result
        } else {
            let result: Float = ammountNumber * rateTo
            return result
        }
    }
}
