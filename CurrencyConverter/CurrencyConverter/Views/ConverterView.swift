//
//  ConverterView.swift
//  CurrencyConverter
//

import SwiftUI

struct ConverterView: View {
    
    @ObservedObject var viewModel: ConverterViewModel
    @State private var ammountFrom: String = "0"
    @State private var ammountTo: String = "0"
    @State private var isForward: Bool = true
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: HorizontalAlignment.center, spacing: 0.0, content: {
                HStack(alignment: VerticalAlignment.center, spacing: 0.0) {
                    Text(viewModel.listSupportedCurrencies[viewModel.convertFromIndex].currencyAbbreviation)
                        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
                        .clipped()
                        .padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
                    
                    Button {
                        isForward = !isForward
                    } label: {
                        if(isForward) {
                            Image(systemName: "arrow.right")
                        } else {
                            Image(systemName: "arrow.left")
                        }
                    }
                    .frame(maxHeight: CGFloat.infinity)
                    .frame(width: 44.0)
                    .padding()
                    .border(Color.blue)
                    
                    Text(viewModel.listSupportedCurrencies[viewModel.convertToIndex].currencyAbbreviation)
                        .frame(maxWidth: CGFloat.infinity, maxHeight: CGFloat.infinity)
                        .clipped()
                        .padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
                }
                .frame(height: 60.0)
                .clipped()
                .padding(EdgeInsets(top: 20.0, leading: 0.0, bottom: 20.0, trailing: 0.0))
                
                HStack(alignment: VerticalAlignment.center, spacing: 0.0) {
                    TextField("Ammount", text: $ammountFrom, onCommit: {
                        
                    })
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle.roundedBorder)
                    .padding()
                    
                    Text("=")
                    
                    TextField("Ammount", text: $ammountTo, onCommit: {
                        
                    })
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle.roundedBorder)
                    .padding()
                }
                
                Button {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    if(isForward) {
                        ammountTo = String(viewModel.convert(ammount: ammountFrom, reverse: false))
                    } else {
                        ammountFrom = String(viewModel.convert(ammount: ammountTo, reverse: true))
                    }
                    if(!viewModel.allConversions.isEmpty) {
                        viewModel.allConversions.removeAll()
                        calculateConversions()
                    }
                } label: {
                    Text("Convert")
                }
                .frame(height: 44.0)
                .frame(maxWidth: CGFloat.infinity)
                .border(Color.blue)
                .padding()
                
                Button {
                    self.calculateConversions()
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    if(viewModel.allConversions.isEmpty) {
                        Text("Show All Currencies")
                    } else {
                        Text("Hide All Currencies")
                    }
                }
                .frame(height: 44.0)
                .frame(maxWidth: CGFloat.infinity)
                .border(Color.blue)
                .padding()
                
                if(!viewModel.allConversions.isEmpty) {
//                    List {
                        ForEach(viewModel.allConversions, id: \.self) { item in
                            Text(item)
                        }
//                    }
                }
                
                Spacer()
            })
        }
        .background(Color(red: 215.0/255.0, green: 241.0/255.0, blue: 252.0/255.0))
        .task {
            ammountFrom = viewModel.ammount
            let from = viewModel.listSupportedCurrencies[viewModel.convertFromIndex].currencyAbbreviation
            await viewModel.getConversionRatesAsync(currency: from)
        }
//        .onAppear {
//            let from = viewModel.listSupportedCurrencies[viewModel.convertFromIndex].currencyAbbreviation
//            viewModel.getConversionRates(currency: from)
//            ammountFrom = viewModel.ammount
//        }
    }
    
    func calculateConversions() {
        if(viewModel.allConversions.isEmpty) {
            let ammount = Float(ammountFrom) ?? 0.0
            for (key, value) in viewModel.conversionRates.conversion_rates! {
                viewModel.allConversions.append(String.init(format: "%1$@ - %2$f", key, (ammount * value)))
            }
            viewModel.allConversions.sort()
        } else {
            viewModel.allConversions.removeAll()
        }
    }
}

#Preview {
    @Previewable @StateObject var viewModel: ConverterViewModel = ConverterViewModel()
    ConverterView(viewModel: viewModel)
}
