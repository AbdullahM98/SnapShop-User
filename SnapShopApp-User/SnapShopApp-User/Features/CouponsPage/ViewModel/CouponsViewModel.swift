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
                print("Error fetching price rule by id: \(error)")
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
    func setUpCouponsDict() {
        for (key,value) in dict{
            print("key is ",key.code)
            print("value is",value)
        }
    }
    func getDraftOrderById(){
        guard let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId") else { return }
        print("User Have DraftOrder and its ID is : \(orderID)")
        
        Network.shared.request("https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID).json", method: "GET", responseType: DraftOrderItem.self) { [weak self] result in
            switch result{
            case .success(let order):
                DispatchQueue.main.async {
                    guard let draftOrder = order.draft_order else {return}
                    self?.orderToUpdate = draftOrder
                    
                }
            case .failure(let err):
                print("Error get the user order : \(err)")
                
                
            }
        }
    }
    
    
    func fetchPriceRulesByIdForApplyingCoupons(id: Int) {
        Network.shared.request("\(Support.baseUrl)/price_rules/\(String(describing: id)).json", method: "GET", responseType: PriceRulesRoot.self) { [weak self] result in
            switch result {
            case .success(let response):
                print("BeforeCoupons")
                DispatchQueue.main.async {[weak self] in
                    print("here is the preice rule response,",response.price_rule?.value,"Value", response.price_rule?.id)
                    self?.prepareAppliedDiscount(priceRuleData: response.price_rule ?? PriceRule(id: 0, value_type: "", value: "", customer_selection: "", title: ""))
                    
                }
                print("AfterCoupons")
                
            case .failure(let error):
                print("Error fetching price rule by id: \(error)")
            }
        }
    }
    func prepareAppliedDiscount(priceRuleData:PriceRule) {
        let newValue = abs(Double(priceRuleData.value ?? "0.0") ?? 0.0)
        print(newValue)
        setUpCouponsDict()
        var foundKey: String?
        for (key, value) in dict {
            if value.id == priceRuleData.id {
                foundKey = key.code
                break // Exit loop once the key is found
            }
        }
        let couponsToApply = AppliedDiscount(description: foundKey ?? "SUMMER", value_type: priceRuleData.value_type, value: String(newValue), amount: priceRuleData.value, title: priceRuleData.title)
        print(couponsToApply,"IS THIS NIL")
        
        self.applyCouponOnDraftOrder(couponToApply: couponsToApply)
    }
    
    func applyCouponOnDraftOrder(couponToApply: AppliedDiscount){
        print(" before Applying The Coupons \(String(describing: self.orderToUpdate?.applied_discount))")
        self.orderToUpdate?.applied_discount = couponToApply
        print(" after Applying The Coupons \(String(describing: self.orderToUpdate?.applied_discount))")
        
        guard let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId") else { return }
        print("The Id Of The Order is ->>>> \(orderID)")
        let updatedOrder = DraftOrderItem(draft_order: self.orderToUpdate)
        Network.shared.updateData(object: updatedOrder, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID).json" ){result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Draft Applying Couons Updated Successfully")
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("Error updating user Coupons On draft order: \(error)")
            }
        }
    }
}
