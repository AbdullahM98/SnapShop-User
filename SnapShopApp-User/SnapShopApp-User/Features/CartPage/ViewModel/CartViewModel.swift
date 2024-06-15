//
//  CartViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import Foundation
import SwiftUI
class CartViewModel :ObservableObject{
    //order to append new line item
    @Published var userOrder:DraftOrderItemDetails?
    //user lineitems
    @Published private (set) var lineItems:[DraftOrderLineItem]?
    @Published var viewState:CartViewState
    @Published var shippingAddress:DraftOrderAddress?
    @Published var discountCodeKey: String?
    @Published var isLoading = true
    init(){
        print("CVM INIT")
        if UserDefaults.standard.bool(forKey: Support.isLoggedUDKey) {
            viewState = .userActive
//            self.getCardDraftOrder()
        }else{
            viewState = .userInActive
        }
        
        
    }
//    //get all draft orders
//    func getCardDraftOrder(){
//        Network.shared.request("\(Support.baseUrl)/draft_orders.json", method: "GET", responseType: ListOfDraftOrders.self) { [weak self] result in
//            switch result {
//            case .success(let response):
//                DispatchQueue.main.async {
//                    self?.viewState = .userActive
//                    self?.draft = response.draft_orders
//                    self?.total = 0
//                    self?.getSpecificUserCart()
//                    print("app have orders ",self?.draft?.count ?? 0,"ssssss")
//                }
//            case .failure(let error):
//                print("Error fetching card draft order: \(error)")
//                self?.viewState = .userInActive
//
//            }
//        }
//    }
//    //get user draft order
//    func getSpecificUserCart(){
//        let newDraft = draft?.filter({ item in
//            item.customer?.id == (UserDefaultsManager.shared.getUserId(key: Support.userID) ?? 0)
//        })
//        self.userOrders = newDraft ?? []
//        self.shippingAddress = self.userOrders.first?.shipping_address
//        self.lineItems = self.userOrders.first?.line_items ?? []
//        print("Abduullah has ",newDraft?.count ?? 0,"orders")
//        print("Line Items is \(self.lineItems.count) count")
//        for order in self.userOrders {
//            total += Double(order.subtotal_price ?? "-200") ?? -100
//        }
//        discountCodeKey = self.userOrders.first?.applied_discount?.description
//        isLoading = false
//        print(userOrders.first?.total_price ?? 0)
//
//    }
    //method to delete
    func getDraftOrderById(){
        guard let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId") else { return }
        print("order ID is -> ",orderID)
        print("user has order -> ",UserDefaultsManager.shared.getUserHasDraftOrders(key: "HasDraft"))
        if UserDefaultsManager.shared.getUserHasDraftOrders(key: "HasDraft") ?? false{
            
            Network.shared.request("https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID).json", method: "GET", responseType: DraftOrderItem.self) { [weak self] result in
                switch result{
                case .success(let order):
                    DispatchQueue.main.async {
                        self?.userOrder = order.draft_order
                        guard let items = self?.userOrder?.line_items  else { return }
                        guard let newAddress = self?.userOrder?.shipping_address else { return }
                        self?.shippingAddress = newAddress
                        print("Coupon is \(self?.userOrder?.applied_discount?.description ?? "NONO")")
                        self?.lineItems = items
                        self?.isLoading = false
                    }
                case .failure(let err):
                    print("Error get the user order : \(err)")
                    print("Error is \(err.localizedDescription)")
                }
            }
        }else{
            self.lineItems = nil
            self.userOrder = nil
            self.isLoading = false
        }
    }
    
    //delete item from drafts
    func deleteLineItemFromDraftOrder(lineItem:DraftOrderLineItem){
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
            let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId")
            let updatedOrder = DraftOrderItem(draft_order: self.userOrder)
            Network.shared.updateData(object: updatedOrder, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID ?? 0).json" ){  [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
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
        let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId")
        Network.shared.deleteObject(with: "\(Support.baseUrl)/draft_orders/\(orderID ?? 0).json") { [weak self] result in
               print(result?.localizedDescription ?? "no error")
            DispatchQueue.main.async {
                UserDefaultsManager.shared.setUserHasDraftOrders(key: "HasDraft", value: false)
                   self?.getDraftOrderById()
            }
           }
       }
    
    func postAsCompleted(){
        guard let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId") else { return }
        let updatedOrder = userOrder
        Network.shared.updateData(object: updatedOrder, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID)/complete.json" ){result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Completed  Successfully")
                    self.deleteCardDraftOrder()
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("Error completing: \(error)")
            }
        }
    }

    
}
enum CartViewState {
    case userInActive
    case userActive
    case loading
}
