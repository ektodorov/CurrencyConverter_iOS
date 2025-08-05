//
//  CurrencyApi.swift
//  CurrencyConverter
//

import Foundation

class CurrencyApi {
    
    //this is not going to be hidden behind a microservice on the API Gateway that we don't have for this project, but lets at least have something
    static var kAPI_Key = ""
    static let apiKeyArray: Array<String> = ["+","S","O","w","J","l","I","N","9","b","j","m","Z","j","D","1","j","A","Z","G","5","v","S","u","c","g","I","X","c","z","9","Y","6","N","C","0","z","p","i","b","T","V","+","t","X","I","+","j","s","b","7","W","A","0","n","/","H","M","e","X","v","4","k","m","J","3","F","3","r","g","=","="]
    static let kURLSupportedCurrencies = "https://v6.exchangerate-api.com/v6/%@/codes"
    static let kURLConversionRates = "https://v6.exchangerate-api.com/v6/%1$@/latest/%2$@"
    
    func supportedCurrencies(completion: @escaping (Array<Currency>)->Void) {
        let urlString = String.init(format: CurrencyApi.kURLSupportedCurrencies, CurrencyApi.kAPI_Key)
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataContent = data else {
                return
            }
            do {
                let decodedData: SupportedCurrencies = try JSONDecoder().decode(SupportedCurrencies.self, from: dataContent)
                
                var arrayCurrencies = Array<Currency>()
                for item: Array<String> in decodedData.supported_codes! {
                    if(item.isEmpty) {
                        continue
                    }
                    if(item.count == 1) {
                        let currency = Currency(currencyAbbreviation: item[0])
                        arrayCurrencies.append(currency)
                    } else {
                        let currency = Currency(currencyAbbreviation: item[0], currencyName: item[1])
                        arrayCurrencies.append(currency)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(arrayCurrencies)
                }
            } catch let error {
                print("CurrencyApi, \(#line), \(#function), error=\(error)")
            }
        }.resume()
    }
    
    func supportedCurrenciesAsync() async -> Array<Currency> {
        var arrayCurrencies = Array<Currency>()
        let urlString = String.init(format: CurrencyApi.kURLSupportedCurrencies, CurrencyApi.kAPI_Key)
        let url = URL(string: urlString)!
        do {
            let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)
            let decodedData: SupportedCurrencies = try JSONDecoder().decode(SupportedCurrencies.self, from: data)
            
            for item: Array<String> in decodedData.supported_codes! {
                if(item.isEmpty) {
                    continue
                }
                if(item.count == 1) {
                    let currency = Currency(currencyAbbreviation: item[0])
                    arrayCurrencies.append(currency)
                } else {
                    let currency = Currency(currencyAbbreviation: item[0], currencyName: item[1])
                    arrayCurrencies.append(currency)
                }
            }
        } catch let error {
            print("CurrencyApi, \(#line), \(#function), error=\(error)")
        }
        return arrayCurrencies
    }
    
    func conversions(forCurrency: String, completion: @escaping (ConversionRates)->Void) {
        let urlString = String.init(format: CurrencyApi.kURLConversionRates, CurrencyApi.kAPI_Key, forCurrency)
        let url = URL(string: urlString)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let dataContent = data else {
                return
            }
            do {
                let decodedData: ConversionRates = try JSONDecoder().decode(ConversionRates.self, from: dataContent)
                
                DispatchQueue.main.async {
                    completion(decodedData)
                }
            } catch let error {
                print("CurrencyApi, \(#line), \(#function), error=\(error)")
            }
        }.resume()
    }
    
    func conversionsAsync(forCurrency: String) async -> ConversionRates? {
        let urlString = String.init(format: CurrencyApi.kURLConversionRates, CurrencyApi.kAPI_Key, forCurrency)
        let url = URL(string: urlString)!
        var conversionRates: ConversionRates? = nil
        do {
            let (data, _): (Data, URLResponse) = try await URLSession.shared.data(from: url)
            conversionRates = try JSONDecoder().decode(ConversionRates.self, from: data)
        } catch let error {
            print("CurrencyApi, \(#line), \(#function), error=\(error)")
        }
        return conversionRates
    }
}
