//
//  FilterBar.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct FilterBar: View {
    @State private var selectedButton: String = "All"
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView(.horizontal) {
            
            HStack {
                FilterButton(buttonName: "All", nameWidth: 60, isSelected: selectedButton == "All") {
                    selectedButton = "All"
                    viewModel.fetchProducts()
                }
                FilterButton(buttonName: "Kid", nameWidth: 60, isSelected: selectedButton == "Kid") {
                    selectedButton = "Kid"
                    viewModel.fetchProductsInCollection(collectionID: "308903805107")
                }
                FilterButton(buttonName: "Men", nameWidth: 60, isSelected: selectedButton == "Men") {
                    selectedButton = "Men"
                    viewModel.fetchProductsInCollection(collectionID: "308903739571")
                }
                FilterButton(buttonName: "Women", nameWidth: 90, isSelected: selectedButton == "Women") {
                    selectedButton = "Women"
                    viewModel.fetchProductsInCollection(collectionID: "308903772339")
                }
                FilterButton(buttonName: "SALE", nameWidth: 70, isSelected: selectedButton == "SALE") {
                    selectedButton = "SALE"
                    viewModel.fetchProductsInCollection(collectionID: "308904657075")
                }
                FilterButton(buttonName: "Home page", nameWidth: 100, isSelected: selectedButton == "Home page") {
                    selectedButton = "Home page"
                    viewModel.fetchProductsInCollection(collectionID: "308899152051")
                }
            }
        }
        .padding()
        .scrollIndicators(.hidden)
    }
}

#Preview {
    FilterBar(viewModel: HomeViewModel())
}
