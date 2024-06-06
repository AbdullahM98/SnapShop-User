//
//  CouponsViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

class CouponsViewModel :ObservableObject{
    @Published var coupones: [DiscountCodes] = []
    @Published var priceRules: [PriceRule] = []
    @Published var singleRule:PriceRule?
    @Published var dict: [DiscountCodes:PriceRule] = [:]
    init(){
        fetchPriceRules()
    }
    func fetchCoupons(){
        DispatchQueue.main.async { [weak self] in
            self?.coupones.removeAll()
        }
        for rule in self.priceRules{
            Network.shared.request("\(Support.baseUrl)/price_rules/\(String(describing: rule.id ?? 1123082305715))/discount_codes.json", method: "GET", responseType: DiscountCodesRoot.self) { [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self?.coupones += response.discount_codes ?? []
                        self?.setUpDict()
                    }
                    
                case .failure(let error):
                    print("Error fetching data1: \(error)")
                }
            }
        }
    }
    func fetchPriceRules(){
        Network.shared.request("\(Support.baseUrl)/price_rules.json", method: "GET", responseType: PriceRulesArray.self) { [weak self] result in
            switch result {
            case .success(let response):
                print("im in switch price rules")
                DispatchQueue.main.async {
                    self?.priceRules = response.price_rules ?? []
                }
                print("before fetching coupons")
                self?.fetchCoupons()
                print("afterFetching Coupons")
                
            case .failure(let error):
                print("Error fetching data2: \(error)")
            }
        }
    }
    func fetchPriceRulesById(id:Int){
        Network.shared.request("\(Support.baseUrl)/price_rules/\(String(describing: id)).json", method: "GET", responseType: PriceRulesRoot.self) { [weak self] result in
            switch result {
            case .success(let response):
                print("im in switch price rules")
                DispatchQueue.main.async {
                    self?.singleRule = response.price_rule
                }
                print("before fetching coupons")
                self?.fetchCoupons()
                print("afterFetching Coupons")
                
            case .failure(let error):
                print("Error fetching data2: \(error)")
            }
        }
    }
    func setUpDict(){
        for code in coupones {
            for rule in priceRules {
                if code.price_rule_id == rule.id {
                    dict[code] = rule
                }
            }
        }
    }
}
