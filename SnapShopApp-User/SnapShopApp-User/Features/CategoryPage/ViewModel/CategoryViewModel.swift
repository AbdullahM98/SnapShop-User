//
//  CategoryViewModel.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import Foundation

class CategoryViewModel:ObservableObject{
    @Published var filteredProducts: [PopularProductItem] = []
    @Published var categoryProducts: [PopularProductItem] = []
    @Published var products: [PopularProductItem] = []
    @Published var isLoading = true
    
    init() {
        print("CategoryVM INIT")
    }
    deinit {
        print("CategoryVM DEINIT")
    }
    
    func filterProducts(by searchText: String) {
            if searchText.isEmpty {
                filteredProducts = categoryProducts
            } else {
                filteredProducts = categoryProducts.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
            }
    }
    
    
    func fetchProducts() {
        Network.shared.request("\(Support.baseUrl)/products.json", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    var uniqueProductIDs: Set<String> = Set()
                    var uniqueProducts: [PopularProductItem] = []
                    for product in response.products ?? [] {
                        if !uniqueProductIDs.contains(product.title ?? "0") && product.image != nil {
                            uniqueProductIDs.insert(product.title ?? "0")
                            uniqueProducts.append(product)
                        }
                    }
                    self?.isLoading = false
                    self?.products = uniqueProducts
                    self?.categoryProducts = uniqueProducts
                    self?.filteredProducts = uniqueProducts
                }
            case .failure(let error):
                print("Error fetching products")
                print("Error fetching data: \(error)")
            }
        }
    }
    func fetchProductsInCollection(collectionID:String){
        Network.shared.request("\(Support.baseUrl)/collections/\(collectionID)/products.json", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.categoryProducts = response.products ?? []
                    self?.filteredProducts = response.products ?? []
                }
            case .failure(let error):
                print("Error fetching products in collection")
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func fetchProductsByCategory(category: String) {
        Network.shared.request("\(Support.baseUrl)/products.json?product_type=\(category)", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.categoryProducts = response.products ?? []
                    self?.filteredProducts = response.products ?? []
                }
            case .failure(let error):
                print("Error fetching products by category")
                print("Error fetching data: \(error)")
            }
        }
    }
}
