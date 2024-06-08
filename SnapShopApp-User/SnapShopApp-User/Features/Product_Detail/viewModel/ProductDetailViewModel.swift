//
//  ProductViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 06/06/2024.
//

import Foundation
import Combine
import SwiftUI
class ProductDetailViewModel :ObservableObject{
    @Published var myOrder:DraftOrderDetails?
    @Published var vendorTitle:String = "Nike"
    @Published var currentCurrency:String = "USD"
    @Published var price:String = "300.00"
    @Published var availbleQuantity  = "30"
    @Published var productTitle  = "T-shirt with long sleeves and pocket an sth else "
    @Published var productDecription  = "Experience ultimate comfort and effortless style with our Oversized T-Shirt. Made from high-quality, breathable cotton, this T-shirt is designed to provide a relaxed fit that drapes beautifully over any body type. Whether you're lounging at home, running errands, or meeting friends, this versatile piece is perfect for any casual occasion."
    @Published var selectedColor: Color? = nil
    @Published var product: ProductModel?
    @Published var errorMessage: String?
    @Published var imgUrl :String?
    private var cancellables = Set<AnyCancellable>()
    func fetchProductByID(_ productID: String) {
        Network.shared.getItemByID(productID, type: ProductResponse.self, endpoint: "products")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch product: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] productResponse in
                DispatchQueue.main.async {
                    self?.product = productResponse.product
                    self?.setUpUI(product: productResponse.product!)
                    print(productResponse.product?.product_type ?? "No product type")
                }
            })
            .store(in: &cancellables)
    }
    
    func setUpUI(product: ProductModel) {
        print("Setting up UI with product ID: \(product.id ?? 0)")
        self.vendorTitle = product.vendor ?? "Unknown"
        self.productDecription = product.body_html ?? "No Description"
        self.productTitle = product.title ?? "NO title"
        self.price = product.variants?[0].price ?? "30"
        self.imgUrl = product.image?.src
    }
    
    
    
    
    func postCardDraftOrder(draftOrder:DraftOrder){
        Network.shared.postData(object: draftOrder, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders.json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.myOrder = response.draft_order
                    print("HemaMar3i is Here",self?.myOrder?.name)
                }
                print("HElllllo")
            case .failure(let error):
                print("Error fetching data2: \(error)")
            }
        }
    }
}
