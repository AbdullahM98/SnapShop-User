//
//  CurrencyView.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 11/06/2024.
//

import SwiftUI


struct CurrencyView: View {
    @ObservedObject var viewModel: CurrencyViewModel
    @State private var searchText = ""
    @Environment(\.presentationMode) var presentationMode
    
    var filteredCurrencies: [(String, Double)] {
        guard let conversionRates = viewModel.currenciesList?.conversion_rates else {
            return []
        }
        
        if searchText.isEmpty {
            return conversionRates.sorted(by: { $0.key < $1.key })
        } else {
            // Filter based on currency code or full name
            return conversionRates.filter { (currencyCode, _) in
                let lowercasedSearchText = searchText.lowercased()
                let currencyFullName = viewModel.currencyFullNames[currencyCode]?.lowercased() ?? ""
                
                return currencyCode.lowercased().contains(lowercasedSearchText) || currencyFullName.contains(lowercasedSearchText)
            }
            .sorted(by: { $0.key < $1.key })
        }
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search currency...", text: $searchText)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .frame(height: 44)
            }
            .frame(height: 20)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal,16)
            
            ScrollView {
                ForEach(filteredCurrencies, id: \.0) { currencyCode, rate in
                    NavigationLink(destination: EmptyView(), isActive: Binding.constant(false), label: {
                        HStack {
                            Text("\(currencyCode) - \(viewModel.currencyFullNames[currencyCode] ?? "Unknown Currency")")
                                .font(.headline)
                                .foregroundColor(Color(uiColor: UIColor.darkGray))
                            Spacer()
                            Text(String(format: "%.2f", rate))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .frame(height: 60)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(UIColor.systemGroupedBackground))
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                        .onTapGesture {
                            // Store selected currency in UserDefaults
                            UserDefaults.standard.set(currencyCode, forKey: "selectedCurrency")
                            UserDefaults.standard.set(rate, forKey: "currencyValue")
                            // Dismiss the view
                            presentationMode.wrappedValue.dismiss()
                        }
                    })
                }
            }
            .navigationBarTitle("Currencies")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
        }
        .onAppear {
            viewModel.fetchingCurrencies()
        }
    }
}

#Preview {
    CurrencyView(viewModel: CurrencyViewModel())
}
