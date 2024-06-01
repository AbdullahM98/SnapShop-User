//
//  HomeSearchBar.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 27/05/2024.
//

import SwiftUI

struct HomeSearchBar: View {
    @State private var searchText: String = ""
    
    var body: some View {
           HStack {
               Image(systemName: "magnifyingglass")
                   .foregroundColor(.gray)
               TextField("Search here .....", text: $searchText)
                   .padding(8)
                   .background(Color(.systemGray6))
                   .cornerRadius(8)
                   .frame(height: 44)
           }
           .frame(height: 44)
           .padding(.horizontal)
           .padding(.vertical, 8)
           .background(Color(.systemGray6))
           .cornerRadius(10)
           .padding(.horizontal,16)
           
    }
}

#Preview {
    HomeSearchBar()
}
