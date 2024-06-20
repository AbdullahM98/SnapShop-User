//
//  CurrencyView.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 11/06/2024.
//

import SwiftUI


struct CurrencyView: View {
    @StateObject var viewModel: CurrencyViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search currency...", text: $viewModel.searchText)
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
                ForEach(viewModel.filteredCurrencies, id: \.0) { currencyCode, rate in
                    NavigationLink(destination: EmptyView(), isActive: Binding.constant(false), label: {
                        HStack {
                            Text("\(currencyCode) - \(viewModel.currencyFullNames[currencyCode] ?? "Unknown Currency")")
                                .font(.headline)
                                .foregroundColor(currencyCode == UserDefaultsManager.shared.selectedCurrencyCode ? .red : Color(uiColor: UIColor.darkGray))
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
                            UserDefaultsManager.shared.selectedCurrencyCode = "\(currencyCode)"
                            UserDefaultsManager.shared.selectedCurrencyValue = "\(rate)"
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


struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(viewModel: CurrencyViewModel())
    }
}
