//
//  CategoryViewModel.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import Foundation

// MARK: - CategoryViewModel

class CategoryViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var allProducts: [PopularProductItem] = []
    @Published var collectionProducts: [PopularProductItem] = []
    @Published var filteredProducts: [PopularProductItem] = []
    @Published var isLoading = true
    @Published var searchText: String = ""
    
    // MARK: - Data Fetching Methods
    
    /// Fetches all products from the network.
    func fetchProducts() {
        Network.shared.request("\(Support.baseUrl)/products.json", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.allProducts = response.products ?? []
                    self?.filterProducts(selectedCategory: "ALL", selectedCollection: "ALL", searchText: self?.searchText ?? "")
                }
            case .failure:
                self?.isLoading = false
                break
            }
        }
    }
    
    /// Fetches products belonging to a specific collection.
    ///
    /// - Parameters:
    ///   - collectionID: The ID of the collection.
    ///   - completion: A completion handler to be called after fetching is complete.
    func fetchProductsInCollection(collectionID: String, completion: @escaping () -> Void) {
        Network.shared.request("\(Support.baseUrl)/products.json?collection_id=\(collectionID)", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.collectionProducts = response.products ?? []
                    completion()
                }
            case .failure:
                completion()
                break
            }
        }
    }
    
    // MARK: - Product Filtering Method
    
    /// Filters products based on the selected category, collection, and search text.
    ///
    /// - Parameters:
    ///   - selectedCategory: The category to filter by. Use "ALL" to include all categories.
    ///   - selectedCollection: The collection to filter by. Use "ALL" to include all collections.
    ///   - searchText: The search text to filter by. Defaults to an empty string.
    func filterProducts(selectedCategory: String, selectedCollection: String, searchText: String = "") {
        let baseProducts = selectedCollection == "ALL" ? allProducts : collectionProducts
        var filtered = baseProducts
        
        // Filter by category
        if selectedCategory != "ALL" {
            filtered = filtered.filter { product in
                return product.product_type == selectedCategory
            }
        }
        
        // Filter by search text
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
