//
//  CartViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import Foundation
import SwiftUI

// MARK: - CartViewModel

class CartViewModel :ObservableObject{
    
    // MARK: - Published Properties

    //order to append new line item
    @Published var userOrder:DraftOrderItemDetails?
    //user lineitems
    @Published private (set) var lineItems:[DraftOrderLineItem]? {
        didSet {
            UserDefaultsManager.shared.notifyCart = lineItems?.count ?? 0
        }
    }
    @Published var viewState:CartViewState
    @Published var shippingAddress:DraftOrderAddress?
    @Published var isLoading = true
    @Published var isCheckOutLoading = true
    
    // MARK: - Initializer

    init(){
        print("CVM INIT")
        if UserDefaults.standard.bool(forKey: Support.isLoggedUDKey) {
            viewState = .userActive
        }else{
            viewState = .userInActive
        }
    }
    
    // MARK: - Fetch Methods

    //method to delete
    func getDraftOrderById(){
        print("user has order -> ",UserDefaultsManager.shared.hasDraft)
        if UserDefaultsManager.shared.hasDraft == true ?? false{
            guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
            print("order ID is -> ",orderID)
            Network.shared.request("\(Support.baseUrl)/draft_orders/\(orderID).json", method: "GET", responseType: DraftOrderItem.self) { [weak self] result in
                switch result{
                case .success(let order):
                    DispatchQueue.main.async {
                        self?.userOrder = order.draft_order
                        guard let items = self?.userOrder?.line_items  else { return }
                        self?.lineItems = items
                        guard let newAddress = self?.userOrder?.shipping_address else { return }
                        self?.shippingAddress = newAddress
                        print("Coupon is \(self?.userOrder?.applied_discount?.description ?? "NONO")")
                        self?.isLoading = false
                        self?.isCheckOutLoading = false
                    }
                case .failure(let err):
                    print("Error get the user order : \(err)")
                    print("Error is \(err.localizedDescription)")
                    DispatchQueue.main.async {
                        SnackBarHelper.showSnackBar(message: "Couldnt load Card , please try again", color: Color.red)
                        self?.viewState = .userInActive
                    }
                }
            }
        }else{
            self.lineItems = nil
            self.userOrder = nil
            self.isLoading = false
        }
    }
    
    // MARK: - Delete Methods
    
    //delete item from drafts
    func deleteLineItemFromDraftOrder(lineItem:DraftOrderLineItem){
        isLoading = true
        //if this is the only item -> delete the  all draft order
        if userOrder?.line_items?.count == 1 {
            //delete draft itself
            deleteCardDraftOrder()
        }else{
            //else delete item and update
            print(self.userOrder?.line_items?.count ?? 0)
            self.userOrder?.line_items?.removeAll(where: { item in
                item.id == lineItem.id
            })
            print(self.userOrder?.line_items?.count ?? 0)
            guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
            let updatedOrder = DraftOrderItem(draft_order: self.userOrder)
            Network.shared.updateData(object: updatedOrder, to: "\(Support.baseUrl)/draft_orders/\(orderID).json" ){  [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async { [weak self] in
                        print(response.draft_order?.line_items?.count ?? 0)
                        self?.getDraftOrderById()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    print("Error updating user draft order: \(error)")
                }
            }
        }
    }
    //delete draft itself
    func deleteCardDraftOrder(){
        guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
        Network.shared.deleteObject(with: "\(Support.baseUrl)/draft_orders/\(orderID).json") { [weak self] result in
            print(result?.localizedDescription ?? "no error")
            DispatchQueue.main.async { [weak self] in
                UserDefaultsManager.shared.hasDraft = false
                UserDefaultsManager.shared.userDraftId = 0
                self?.getDraftOrderById()
            }
        }
    }
    
    // MARK: - Order Completion Methods
    
    func postAsCompleted(){
        isCheckOutLoading = true
        guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
        let updatedOrder = userOrder
        Network.shared.updateData(object: updatedOrder, to: "\(Support.baseUrl)/draft_orders/\(orderID)/complete.json" ){result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Completed  Successfully")
                    self.deleteCardDraftOrder()
                    self.isCheckOutLoading = false
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("Error completing: \(error)")
            }
        }
    }
    
    // MARK: - Coupon Application Methods
    
    func fetchPriceRulesByIdForApplyingCoupons(id: Int) {
        isCheckOutLoading = true
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
        
        let couponsToApply = AppliedDiscount(description: "CouponDescription", value_type: priceRuleData.value_type, value: String(newValue), amount: priceRuleData.value, title: priceRuleData.title)
        print(couponsToApply,"IS THIS NIL??????")
        
        self.applyCouponOnDraftOrder(couponToApply: couponsToApply)
    }
    
    func applyCouponOnDraftOrder(couponToApply: AppliedDiscount){
        isCheckOutLoading = true
        print(" before Applying The Coupons \(String(describing: self.userOrder?.applied_discount))")
        self.userOrder?.applied_discount = couponToApply
        print(" after Applying The Coupons \(String(describing: self.userOrder?.applied_discount))")
        guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
        print("The Id Of The Order is ->>>> \(orderID)")
        let updatedOrder = DraftOrderItem(draft_order: self.userOrder)
        Network.shared.updateData(object: updatedOrder, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID).json" ){result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    print("Draft Applying Couons Updated Successfully")
                    self.getDraftOrderById()
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("Error updating user Coupons On draft order: \(error)")
            }
        }
    }
    
    
}

// MARK: - CartViewState

enum CartViewState {
    case userInActive
    case userActive
    case loading
}
