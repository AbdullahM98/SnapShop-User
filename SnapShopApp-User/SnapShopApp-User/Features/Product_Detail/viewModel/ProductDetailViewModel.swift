//
//  ProductViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 06/06/2024.
//

import Foundation
import Combine
class ProductDetailViewModel :ObservableObject{
    @Published var vendorTitle:String = "Nike"
    @Published var currentCurrency:String = "USD"
    @Published var price:String = "300.00"
    @Published var availbleQuantity  = "30"
    @Published var productTitle  = "30"
    @Published var productDecription  = "Experience ultimate comfort and effortless style with our Oversized T-Shirt. Made from high-quality, breathable cotton, this T-shirt is designed to provide a relaxed fit that drapes beautifully over any body type. Whether you're lounging at home, running errands, or meeting friends, this versatile piece is perfect for any casual occasion."
    
    @Published var product: ProductModel?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()

        func fetchProductByID(_ productID: String) {
            Network.shared.getProductByID(productID)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorMessage = error.localizedDescription
                    }
                }, receiveValue: { product in
                    self.product = product
                })
                .store(in: &cancellables)
        }
    
    func setUpUI(product:ProductModel){
        self.vendorTitle = product.vendor
        self.productDecription = product.body_html
        
        // to be followed
    }
    
}
