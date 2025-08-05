

import Testing
@testable import CurrencyConverter

struct CurrencyConverterTests {

    @Test func convertTest() async throws {
        let converter = ConverterViewModel()
        
        converter.listSupportedCurrencies.append(Currency(currencyAbbreviation: "EUR", currencyName: "Euro", rate: 1.0))
        converter.listSupportedCurrencies.append(Currency(currencyAbbreviation: "USD", currencyName: "United States Dollar", rate: 1.5))
        converter.listSupportedCurrencies.append(Currency(currencyAbbreviation: "BGN", currencyName: "Bulgarian Lev", rate: 0.5))
        
        var rates = Dictionary<String, Float>()
        rates["EUR"] = 1.0
        rates["USD"] = 1.5
        rates["BGN"] = 0.5
        var conversionRates = ConversionRates()
        conversionRates.conversion_rates = rates
        
        converter.conversionRates = conversionRates
        converter.convertToIndex = 0
        #expect(converter.convert(ammount: "1", reverse: false) == 1.0)
        #expect(converter.convert(ammount: "1", reverse: true) == 1.0)
        
        converter.convertToIndex = 1
        #expect(converter.convert(ammount: "10", reverse: false) == 15.0)
        #expect(converter.convert(ammount: "10", reverse: true) == 6.66666667)
        
        converter.convertToIndex = 2
        #expect(converter.convert(ammount: "10", reverse: false) == 5.0)
        #expect(converter.convert(ammount: "10", reverse: true) == 20.0)
    }
    
    
    @Test func supportedCurrenciesTest() async throws {
        let currencyApi = CurrencyApi()
        var currencies: Array<Currency>? = nil
        await withCheckedContinuation { checkedContinuation in
            currencyApi.supportedCurrencies { list in
                currencies = list
                checkedContinuation.resume()
            }
        }
        #expect(currencies != nil)
        #expect((currencies?.count ?? 0) > 0)
    }
    
    @Test func supportedCurrenciesAsyncTest() async throws {
        let currencyApi = CurrencyApi()
        let currencies: Array<Currency> = await currencyApi.supportedCurrenciesAsync()
        #expect(currencies.count > 0)
    }
}
