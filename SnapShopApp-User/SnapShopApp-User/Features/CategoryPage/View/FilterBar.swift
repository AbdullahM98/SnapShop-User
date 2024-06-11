//
//  FilterBar.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct FilterBar: View {
    @State private var selectedButton: String = "All"
    @AppStorage("selectedOption") private var selectedOption: String = "ALL"
    @AppStorage("selectedCollection") private var selectedCollection: String = "ALL"
    @ObservedObject var viewModel: CategoryViewModel

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                FilterButton(buttonName: "All", nameWidth: 60, isSelected: selectedCollection == "ALL") {
                    selectedButton = "All"
                    selectedCollection = "ALL"
                    selectedOption = "ALL"
                    onFilterAllSelected()
                }
                FilterButton(buttonName: "Kid", nameWidth: 60, isSelected: selectedCollection == "Kid") {
                    selectedButton = "Kid"
                    selectedCollection = "Kid"
                    onFilterCollectionSelected("Kid")
                }
                FilterButton(buttonName: "Men", nameWidth: 60, isSelected: selectedCollection == "Men") {
                    selectedButton = "Men"
                    selectedCollection = "Men"
                    onFilterCollectionSelected("Men")
                }
                FilterButton(buttonName: "Women", nameWidth: 90, isSelected: selectedCollection == "Women") {
                    selectedButton = "Women"
                    selectedCollection = "Women"
                    onFilterCollectionSelected("Women")
                }
                FilterButton(buttonName: "SALE", nameWidth: 70, isSelected: selectedCollection == "SALE") {
                    selectedButton = "SALE"
                    selectedCollection = "SALE"
                    onFilterCollectionSelected("SALE")
                }
                FilterButton(buttonName: "Home page", nameWidth: 100, isSelected: selectedCollection == "Home page") {
                    selectedButton = "Home page"
                    selectedCollection = "Home page"
                    onFilterCollectionSelected("Home page")
                }
            }
        }
        .padding()
        .scrollIndicators(.hidden)
    }

    func onFilterAllSelected() {
        viewModel.fetchProducts()
        viewModel.filterProducts(selectedCategory: selectedOption, selectedCollection: "ALL")
    }

    func onFilterCollectionSelected(_ selectedCollection: String) {
        let collectionID: String
        switch selectedCollection {
        case "Kid":
            collectionID = "308903805107"
        case "Men":
            collectionID = "308903739571"
        case "Women":
            collectionID = "308903772339"
        case "SALE":
            collectionID = "308904657075"
        case "Home page":
            collectionID = "308899152051"
        default:
            collectionID = ""
        }

        if collectionID.isEmpty {
            viewModel.filterProducts(selectedCategory: selectedOption, selectedCollection: selectedCollection)
        } else {
            viewModel.fetchProductsInCollection(collectionID: collectionID) {
                viewModel.filterProducts(selectedCategory: self.selectedOption, selectedCollection: selectedCollection)
            }
        }
    }
}

struct FilterBar_Previews: PreviewProvider {
    static var previews: some View {
        FilterBar(viewModel: CategoryViewModel())
    }
}

