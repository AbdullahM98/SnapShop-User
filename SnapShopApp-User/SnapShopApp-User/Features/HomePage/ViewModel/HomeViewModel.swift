//
//  HomeViewModel.swift
//  SnapShop
//
//  Created by husayn on 01/06/2024.
//

import Foundation

class HomeViewModel :ObservableObject{
    @Published var smartCollections: [SmartCollectionsItem] = []
    @Published var products: [PopularProductItem] = []
    @Published var categoryProducts: [PopularProductItem] = []
    @Published var singleCategoryProducts: [PopularProductItem] = []
    @Published var filteredProducts: [PopularProductItem] = []
    @Published private (set) var draft:[DraftOrderItemDetails]?
    @Published private (set) var userOrders:[DraftOrderItemDetails] = []


    
    init(){
        print("HVM INIT")
        fetchBrands()
        fetchProducts()
        getCardDraftOrder()
        filteredProducts = categoryProducts
    }
    
    func filterProducts(by searchText: String) {
            if searchText.isEmpty {
                filteredProducts = categoryProducts
            } else {
                filteredProducts = categoryProducts.filter { $0.title?.localizedCaseInsensitiveContains(searchText) ?? false }
            }
        }
    
    func fetchBrands() {
        Network.shared.request("\(Support.baseUrl)/smart_collections.json", method: "GET", responseType: BrandsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.smartCollections = response.smart_collections ?? []
                }
            case .failure(let error):
                print("Error fetching brands")
                print("Error fetching data: \(error)")
            }
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
    func fetchProductsInCollectionSingle(collectionID:String){
        Network.shared.request("\(Support.baseUrl)/collections/\(collectionID)/products.json", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.singleCategoryProducts = response.products ?? []
                }
            case .failure(let error):
                print("Error fetching products in single collection")
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
    
    func getCardDraftOrder(){
        Network.shared.request("\(Support.baseUrl)/draft_orders.json", method: "GET", responseType: ListOfDraftOrders.self) { [weak self] result in
            switch result {
            case .success(let response):
                print("YLAAA YAH AHMED")
                DispatchQueue.main.async {
                    self?.draft = response.draft_orders
                    print(self?.draft?.count ?? 0)
                    self?.getUserDraftOrders()
                }
                print("3ash YA AHMED")
            case .failure(let error):
                print("Error fetching DraftOrders: \(error)")
            }
        }
    }
    
    func getUserDraftOrders(){
        let newDraft = draft?.filter({ item in
            item.customer?.id == 7290794967219
        })
        print(newDraft?.count)
        self.userOrders = newDraft ?? []
        
        if self.userOrders.count >= 1 {
            print(" user has orders")
            UserDefaultsManager.shared.setUserHasDraftOrders(key: "HasDraft", value: true)
            UserDefaultsManager.shared.setUserDraftOrderId(key: "DraftId", value: self.userOrders.first?.id ?? 0)
        }
    }

}
