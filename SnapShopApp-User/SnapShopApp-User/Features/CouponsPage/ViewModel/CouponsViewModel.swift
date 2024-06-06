//
//  CouponsViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

import Foundation

class CouponsViewModel: ObservableObject {
    @Published var coupones: [DiscountCodes] = []
    @Published var priceRules: [PriceRule] = []
    @Published var singleRule: PriceRule?
    @Published var dict: [DiscountCodes: PriceRule] = [:]
    
    static let shared = CouponsViewModel()
    
    private init() {
        fetchPriceRules()
        print("INIT CouponsVM")
    }
    
    func fetchCoupons() {
        DispatchQueue.main.async { [weak self] in
            self?.coupones.removeAll()
        }
        
        let dispatchGroup = DispatchGroup()
        
        for rule in self.priceRules {
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
        }
    }
    
    func fetchPriceRules() {
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
                print("Error fetching data2: \(error)")
            }
        }
    }
    
    func fetchPriceRulesById(id: Int) {
        Network.shared.request("\(Support.baseUrl)/price_rules/\(String(describing: id)).json", method: "GET", responseType: PriceRulesRoot.self) { [weak self] result in
            switch result {
            case .success(let response):
                print("im in switch price rules")
                DispatchQueue.main.async {
                    self?.singleRule = response.price_rule
                    self?.fetchCoupons()
                }
                print("before fetching coupons")
                
            case .failure(let error):
                print("Error fetching data2: \(error)")
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
