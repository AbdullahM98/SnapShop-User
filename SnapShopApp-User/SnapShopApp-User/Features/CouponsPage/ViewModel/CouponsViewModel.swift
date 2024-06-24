//
//  CouponsViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

class CouponsViewModel: ObservableObject {
    @Published var coupones: [DiscountCodes] = []
    @Published var priceRules: [PriceRule] = []
    @Published var singleRule: PriceRule?
    @Published var dict: [DiscountCodes: PriceRule] = [:]
    @Published var orderToUpdate:DraftOrderItemDetails?
    @Published var isLoading = true
    init() {
        print("INIT CouponsVM")
    }
    deinit{
        print("DEINIT CouponsVM")
    }
    
    func fetchCoupons() {
        DispatchQueue.main.async { [weak self] in
            self?.coupones.removeAll()
        }
        
        let dispatchGroup = DispatchGroup()
        
        for rule in self.priceRules {
            //fetch coupons for every price rule
            dispatchGroup.enter()
            Network.shared.request("\(Support.baseUrl)/price_rules/\(String(describing: rule.id ?? 1123082305715))/discount_codes.json", method: "GET", responseType: DiscountCodesRoot.self) { [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.coupones += response.discount_codes ?? []
                    }
                    
                case .failure(let error):
                    print("Error fetching data1: \(error)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.setUpDict()
            self.isLoading = false
        }
    }
    
    func fetchPriceRules() {
        //fetch all price rules ->
        Network.shared.request("\(Support.baseUrl)/price_rules.json", method: "GET", responseType: PriceRulesArray.self) { [weak self] result in
            switch result {
            case .success(let response):
                print("im in switch price rules")
                DispatchQueue.main.async {
                    self?.priceRules = response.price_rules ?? []
                    self?.fetchCoupons()
                }
                print("before fetching coupons")
                
            case .failure(let error):
                print("Error fetching price rules: \(error)")
            }
        }
    }

    func setUpDict() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            for code in self.coupones {
                for rule in self.priceRules {
                    if code.price_rule_id == rule.id {
                        self.dict[code] = rule
                    }
                }
            }
        }
    }

}
