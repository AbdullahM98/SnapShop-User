//
//  CartViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import Foundation
import SwiftUI
class CartViewModel :ObservableObject{
    @Published var oldOrder:DraftOrderItemDetails?
    @Published private (set) var draft:[DraftOrderItemDetails]?
    @Published private (set) var userOrders:[DraftOrderItemDetails] = []
    @Published private (set) var lineItems:[DraftOrderLineItem] = []
    
    @Published var total: Double = 0.0
    static let shared = CartViewModel()
    private init(){
        self.getCardDraftOrder()
    }
    func getCardDraftOrder(){
        Network.shared.request("\(Support.baseUrl)/draft_orders.json", method: "GET", responseType: ListOfDraftOrders.self) { [weak self] result in
            switch result {
            case .success(let response):
                print("YLAAA YAH AHMED")
                DispatchQueue.main.async {
                    self?.draft = response.draft_orders
                    self?.total = 0
                    self?.getSpecificUserCart()
                    print(self?.draft?.count ?? 0)
                }
                print("3ash YA AHMED")
            case .failure(let error):
                print("Error fetching data2: \(error)")
            }
        }
    }
    func getSpecificUserCart(){
        print("Yla y3mmm")
        let newDraft = draft?.filter({ item in
            item.customer?.id == 7290794967219
        })
        self.userOrders = newDraft ?? []
        self.lineItems = self.userOrders.first?.line_items ?? []
        print("Abduullah has ",newDraft?.count ?? 0,"orders")
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
    func deleteLineItemFromDraftOrder(lineItem:DraftOrderLineItem){
        
        
        if oldOrder?.line_items?.count == 1 {
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
    func deleteCardDraftOrder(){
        let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId")
        Network.shared.deleteObject(with: "\(Support.baseUrl)/draft_orders/\(orderID ?? 0).json") { [weak self] result in
               print(result?.localizedDescription ?? "no error")
            UserDefaultsManager.shared.setUserHasDraftOrders(key: "HasDraft", value: false)

               self?.getCardDraftOrder()
           }
       }
    
    
}
