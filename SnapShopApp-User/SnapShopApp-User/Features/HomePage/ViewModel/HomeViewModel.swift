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
    
    @Published private(set) var appDraftOrder: [DraftOrderItemDetails]?
    @Published private(set) var userLineItems: [DraftOrderLineItem]? {
        didSet {
            //for badge
            UserDefaultsManager.shared.notifyCart = userLineItems?.count ?? 0
            print("user line items to be notified \(userLineItems?.count)")
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
        //fetch all draft orders of the application
        Network.shared.request("\(Support.baseUrl)/draft_orders.json", method: "GET", responseType: ListOfDraftOrders.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.appDraftOrder = response.draft_orders
                    print("--Application Has \(self?.appDraftOrder?.count) Draft Orders --")
                    print("Start Checking if user Have Drafts or not")
                    self?.checkUserDrafts()
                }
            case .failure(let err):
                print("-- There is A Failure Happend When getting Application Draft Orders \(err) --- \(err.localizedDescription)")
                break
            }
        }
    }
    
    // MARK: - Draft Order Methods
    
    func checkUserDrafts() {
        //filter draft orders by user ID
        print("Before Filtering")
        let userDraftOrder = appDraftOrder?.filter { item in
            item.customer?.id == (UserDefaultsManager.shared.getUserId(key: Support.userID) ?? 0)
        }
        print("User Draft Orders ----> \(userDraftOrder?.count) must be 1 or 0 lw one ydkhol if lw 0 ydkhol else")
        if userDraftOrder?.count ?? -1 > 0 {
            //for badge
            self.userLineItems = userDraftOrder?.first?.line_items
            UserDefaultsManager.shared.hasDraft = true
            UserDefaultsManager.shared.userDraftId = userDraftOrder?.first?.id
            print("Inside if ")
            print("User Draft Order is Not Empty!!")
            print("User Has DraftOrders --> \(userDraftOrder?.count) == 1 ")
            print("User Line Items is --> \(self.userLineItems?.count)")
            print("Saving User Have Draft Order and its ID \(userDraftOrder?.first?.id)")
        }else{
            print("inside else")
            print("User Draft Order is Empty!!")
            print("User Have No Draft Order \(UserDefaultsManager.shared.hasDraft) == false")
            print("User Have No Draft Order ID\(UserDefaultsManager.shared.userDraftId) == 0")
        }
    }
}
