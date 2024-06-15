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
    @Published var isLoading = true
    @Published var isLoadingBrandProducts = true
    
    init(){
        print("HVM INIT")
    }
    deinit {
        print("HVM DEINIT")
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
    
    func fetchProductsInCollectionSingle(collectionID:String){
        Network.shared.request("\(Support.baseUrl)/products.json?collection_id=\(collectionID)", method: "GET", responseType: PopularProductsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.isLoadingBrandProducts = false
                    self?.singleCategoryProducts = response.products ?? []
                }
            case .failure(let error):
                print("Error fetching products in single collection")
                print("Error fetching data: \(error)")
            }
        }
    }
    //get all draft orders in the application
    func fetchAllDraftOrdersOfApplication(){
        Network.shared.request("\(Support.baseUrl)/draft_orders.json", method: "GET", responseType: ListOfDraftOrders.self) { [weak self] result in
            switch result {
            case .success(let response):
                print("getting App draft orders")
                DispatchQueue.main.async {
                    self?.draft = response.draft_orders
                    print("app have ",self?.draft?.count ?? 0," draft orders")
                    if UserDefaultsManager.shared.getUserHasDraftOrders(key: "HasDraft") ?? false {
                        self?.getUserDraftOrders()
                    }
                }
            case .failure(let error):
                print("Error fetching DraftOrders: \(error)")
            }
        }
    }
    //see if the use have draft order or no
    func getUserDraftOrders(){
        let userDraftOrder = draft?.filter({ item in
            item.customer?.id == (UserDefaultsManager.shared.getUserId(key: Support.userID) ?? 0)
        })
        print("usser have ",userDraftOrder?.count ?? 0," draft order")
        self.userOrders = userDraftOrder ?? []
        print("User Have No Draft Orders -> ",self.userOrders.count)
        if !self.userOrders.isEmpty {
            print(" user has orders")
            //if have save in user default that he has
            UserDefaultsManager.shared.setUserHasDraftOrders(key: "HasDraft", value: true)
            UserDefaultsManager.shared.setUserDraftOrderId(key: "DraftId", value: self.userOrders.first?.id ?? 0)
        }
    }
}
