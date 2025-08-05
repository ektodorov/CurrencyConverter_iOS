//
//  ContentView.swift
//  CurrencyConverter
//

import SwiftUI

struct MainView: View {
    
    @StateObject private var viewModel: ConverterViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: ConverterViewModel())
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: HorizontalAlignment.center, spacing: 0.0, content: {
                TextField("Ammount", text: $viewModel.ammount, onCommit: {
                    
                })
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle.roundedBorder)
                .padding(Edge.Set.bottom, 20)
                
                if(!viewModel.isLoading) {
                    HStack(alignment: VerticalAlignment.center, spacing: 0.0, content: {
                        Picker("Please select currency 1", selection: $viewModel.convertFromIndex) {
                            ForEach(0..<viewModel.listSupportedCurrencies.count, id: \.self) { (i: Int) in
                                Text(viewModel.listSupportedCurrencies[i].currencyAbbreviation).frame(maxWidth: CGFloat.infinity)
                            }
                        }
                        .border(Color.blue)
                        .clipped()
                        
                        Image(systemName: "arrow.right").padding()
                        
                        Picker("Please select currency 2", selection: $viewModel.convertToIndex) {
                            ForEach(0..<viewModel.listSupportedCurrencies.count, id: \.self) { (i: Int) in
                                Text(viewModel.listSupportedCurrencies[i].currencyAbbreviation).frame(maxWidth: CGFloat.infinity)
                            }
                        }
                        .border(Color.blue)
                        .clipped()
                        
                    })
                    .frame(maxWidth: CGFloat.infinity)
                }
                
                NavigationLink {
                    ConverterView(viewModel: viewModel)
                } label: {
                    Text("Convert")
                        .frame(maxWidth: CGFloat.infinity)
                        .frame(height: 44.0)
                        .border(Color.blue)
                        .padding(EdgeInsets(top: 40.0, leading: 0.0, bottom: 0.0, trailing: 0.0))
                }.disabled(viewModel.ammount.isEmpty)

                Spacer()
            })
            .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
            .padding()
        }
        .task {
            let result: Data? = ConstantsConverter.decrypt(input: Data(base64Encoded: CurrencyApi.apiKeyArray.joined())!)
            let resultStr: String? = String(data: result!, encoding: .utf8)
            CurrencyApi.kAPI_Key = resultStr!
            await self.viewModel.getCurrencyListAsync()
        }
//        .onAppear {
//            self.viewModel.getCurrencyList()
//        }
    }
}

#Preview {
    MainView()
}
