//
//  HomeSearchBar.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 27/05/2024.
//

import SwiftUI

struct HomeSearchBar: View {
    @State private var searchText: String = ""
    @StateObject var viewModel: CategoryViewModel
    @AppStorage("selectedOption") private var selectedOption: String = "ALL"
    @AppStorage("selectedCollection") private var selectedCollection: String = "ALL"

    var body: some View {
           HStack {
               Image(systemName: "magnifyingglass")
                   .foregroundColor(.gray)
               TextField("Search here .....", text: $searchText)
                   .padding(8)
                   .background(Color(.systemGray6))
                   .cornerRadius(8)
                   .frame(height: 44)
                   .onChange(of: searchText) { newValue in
                       viewModel.searchText = newValue
                       viewModel.filterProducts(selectedCategory: selectedOption, selectedCollection: selectedCollection, searchText: newValue)
                   }
           }
           .frame(height: 30).frame(width: 260)
           .padding(.horizontal)
           .padding(.vertical, 8)
           .background(Color(.systemGray6))
           .cornerRadius(10)
           .padding(.horizontal,16)
    }
}

struct HomeSearchBar_Previews: PreviewProvider {
    static var previews: some View {
        HomeSearchBar(viewModel: CategoryViewModel())
    }
}


