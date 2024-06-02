//
//  HomeViewModel.swift
//  SnapShop
//
//  Created by husayn on 01/06/2024.
//

import Foundation

class HomeViewModel :ObservableObject{
    @Published var smartCollections: [SmartCollectionsItem] = []
    @Published var coupones: [DiscountCodes] = []
    init(){
        fetchBrands()
        fetchCoupons()
    }
    
    func fetchBrands() {
        Network.shared.request("\(Support.baseUrl)/smart_collections.json", method: "GET", responseType: BrandsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.smartCollections = response.smart_collections ?? []
                }
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
    func fetchCoupons(){
        Network.shared.request("\(Support.baseUrl)/price_rules/1119217582259/discount_codes.json", method: "GET", responseType: DiscountCodesRoot.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.coupones = response.discount_codes ?? []
                }
                
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}
