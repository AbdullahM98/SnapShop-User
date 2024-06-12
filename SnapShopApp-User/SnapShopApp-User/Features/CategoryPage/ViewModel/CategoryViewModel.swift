//
//  CategoryViewModel.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import Foundation

class CategoryViewModel: ObservableObject {
    @Published var allProducts: [PopularProductItem] = []
    @Published var collectionProducts: [PopularProductItem] = []
    @Published var filteredProducts: [PopularProductItem] = []
    @Published var isLoading = true
    @Published var searchText: String = ""
    
    func fetchProducts() {
        Network.shared.request("\(Support.baseUrl)/products.json", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.allProducts = response.products ?? []
                    self?.filterProducts(selectedCategory: "ALL", selectedCollection: "ALL", searchText: self?.searchText ?? "")
                }
            case .failure(let error):
                print("Error fetching products: \(error)")
            }
        }
    }
    
    func fetchProductsInCollection(collectionID: String, completion: @escaping () -> Void) {
        Network.shared.request("\(Support.baseUrl)/products.json?collection_id=\(collectionID)", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.collectionProducts = response.products ?? []
                    completion()
                }
            case .failure(let error):
                print("Error fetching products in collection: \(error)")
            }
        }
    }
    
    func filterProducts(selectedCategory: String, selectedCollection: String, searchText: String = "") {
            let baseProducts = selectedCollection == "ALL" ? allProducts : collectionProducts
            
            var filtered = baseProducts
            
            if selectedCategory != "ALL" {
                filtered = filtered.filter { product in
                    return product.product_type == selectedCategory
                }
            }
            
            let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if !trimmedSearchText.isEmpty {
                filtered = filtered.filter { product in
                    if let title = product.title?.lowercased() {
                        return title.contains(trimmedSearchText.lowercased())
                    }
                    return false
                }
            }
            
            filteredProducts = filtered
        }
}
