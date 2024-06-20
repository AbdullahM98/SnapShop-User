//
//  HomeViewModel.swift
//  SnapShop
//
//  Created by husayn on 01/06/2024.
//

import Foundation

// MARK: - HomeViewModel

class HomeViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var smartCollections: [SmartCollectionsItem] = []
    @Published var products: [PopularProductItem] = []
    @Published var categoryProducts: [PopularProductItem] = []
    @Published var singleCategoryProducts: [PopularProductItem] = []
    @Published var filteredProducts: [PopularProductItem] = []
    
    @Published private(set) var draft: [DraftOrderItemDetails]?
    @Published private(set) var lineItems: [DraftOrderLineItem]? {
        didSet {
            UserDefaultsManager.shared.notifyCart = lineItems?.count ?? 0
        }
    }
    
    @Published var isLoading = true
    @Published var isLoadingBrandProducts = true
    
    // MARK: - Data Fetching Methods
    
    func fetchBrands() {
        Network.shared.request("\(Support.baseUrl)/smart_collections.json", method: "GET", responseType: BrandsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.smartCollections = response.smart_collections ?? []
                }
            case .failure:
                break
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
                        if let title = product.title, !uniqueProductIDs.contains(title), product.image != nil {
                            uniqueProductIDs.insert(title)
                            uniqueProducts.append(product)
                        }
                    }
                    self?.isLoading = false
                    self?.products = uniqueProducts
                    self?.categoryProducts = uniqueProducts
                    self?.filteredProducts = uniqueProducts
                }
            case .failure:
                break
            }
        }
    }
    
    func fetchProductsInCollectionSingle(collectionID: String) {
        Network.shared.request("\(Support.baseUrl)/products.json?collection_id=\(collectionID)", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoadingBrandProducts = false
                    self?.singleCategoryProducts = response.products ?? []
                }
            case .failure:
                break
            }
        }
    }
    
    func fetchAllDraftOrdersOfApplication() {
        Network.shared.request("\(Support.baseUrl)/draft_orders.json", method: "GET", responseType: ListOfDraftOrders.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.draft = response.draft_orders
                }
            case .failure:
                break
            }
        }
    }
    
    // MARK: - Draft Order Methods
    
    func getUserDraftOrders() {
        let userDraftOrder = draft?.filter { item in
            item.customer?.id == (UserDefaultsManager.shared.getUserId(key: Support.userID) ?? 0)
        }
        
        self.lineItems = userDraftOrder?.first?.line_items
        
        if let draftCount = userDraftOrder?.count, draftCount > 0 {
            UserDefaultsManager.shared.hasDraft = true
            UserDefaultsManager.shared.userDraftId = userDraftOrder?.first?.id
        }
    }
}
