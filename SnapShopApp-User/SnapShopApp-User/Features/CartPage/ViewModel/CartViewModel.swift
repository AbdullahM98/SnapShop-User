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
    @Published var oldOrder:DraftOrderItemDetails?
    //all drafts
    @Published private (set) var draft:[DraftOrderItemDetails]?
    //user draft order
    @Published private (set) var userOrders:[DraftOrderItemDetails] = []
    //user lineitems
    @Published private (set) var lineItems:[DraftOrderLineItem] = []
    @Published var total: Double = 0.0
    @Published var viewState:CartViewState
    @Published var shippingAddress:DraftOrderAddress?
    init(){
        print("CVM INIT")
        if UserDefaults.standard.bool(forKey: Support.isLoggedUDKey) {
            viewState = .userActive
            self.getCardDraftOrder()
        }else{
            viewState = .userInActive
        }
        
        
    }
    //get all draft orders
    func getCardDraftOrder(){
        Network.shared.request("\(Support.baseUrl)/draft_orders.json", method: "GET", responseType: ListOfDraftOrders.self) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.viewState = .userActive
                    self?.draft = response.draft_orders
                    self?.total = 0
                    self?.shippingAddress = self?.oldOrder?.shipping_address
                    self?.getSpecificUserCart()
                    print("app have orders ",self?.draft?.count ?? 0,"ssssss")
                }
            case .failure(let error):
                print("Error fetching card draft order: \(error)")
                self?.viewState = .userInActive

            }
        }
    }
    //get user draft order
    func getSpecificUserCart(){
        print("Yla y3mmm")
        let newDraft = draft?.filter({ item in
            item.customer?.id == (UserDefaultsManager.shared.getUserId(key: Support.userID) ?? 0)
        })
        self.userOrders = newDraft ?? []
        self.shippingAddress = self.userOrders.first?.shipping_address
        self.lineItems = self.userOrders.first?.line_items ?? []
        print("Abduullah has ",newDraft?.count ?? 0,"orders")
        print("Line Items is \(self.lineItems.count) count")
        for order in self.userOrders {
            total += Double(order.subtotal_price ?? "-200") ?? -100
        }
        print(userOrders.first?.total_price ?? 0)
        
    }
    
    func getDraftOrderById(lineItem:DraftOrderLineItem){
        let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId")
        print(orderID ?? 0)
        Network.shared.request("https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID ?? 0).json", method: "GET", responseType: DraftOrderItem.self) { [weak self] result in
            switch result{
            case .success(let order):
                DispatchQueue.main.async {
                    self?.oldOrder = order.draft_order
                    self?.deleteLineItemFromDraftOrder(lineItem: lineItem)
                }
            case .failure(let err):
                print("Error get the user order : \(err)")
                
                
            }
        }
    }
    //delete item from drafts
    func deleteLineItemFromDraftOrder(lineItem:DraftOrderLineItem){
        
        if oldOrder?.line_items?.count == 1 {
            //delete draft itself
            deleteCardDraftOrder()
        }else{
            print(self.oldOrder?.line_items?.count ?? 0)
            self.oldOrder?.line_items?.removeAll(where: { item in
                item.id == lineItem.id
            })
            print(self.oldOrder?.line_items?.count ?? 0)
            let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId")
            let updatedOrder = DraftOrderItem(draft_order: self.oldOrder)
            Network.shared.updateData(object: updatedOrder, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID ?? 0).json" ){  [weak self] result in
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        print(response.draft_order?.line_items?.count ?? 0)
                        self?.getCardDraftOrder()
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
            UserDefaultsManager.shared.setUserHasDraftOrders(key: "HasDraft", value: false)

               self?.getCardDraftOrder()
           }
       }
    
    
}
enum CartViewState {
    case userInActive
    case userActive
    case loading
}
