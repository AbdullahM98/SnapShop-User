//
//  CartViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import Foundation
import SwiftUI
class CartViewModel :ObservableObject{
    @Published private (set) var draft:[DraftOrderResponse2]?
    @Published private (set) var userOrders:[DraftOrderResponse2] = []
    
    @Published var total: Double = 0.0
    static let shared = CartViewModel()
    private init(){
        self.getCardDraftOrder()
    }
    func getCardDraftOrder(){
        Network.shared.request("\(Support.baseUrl)/draft_orders.json", method: "GET", responseType: Resp.self) { [weak self] result in
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
        
        print("Abduullah has ",newDraft?.count ?? 0,"orders")
        for order in self.userOrders {
            total += Double(order.total_price ?? "-200") ?? -100
        }
        print(userOrders.first?.total_price)
        
    }
    
    func deleteCardDraftOrder(id:Int){
        Network.shared.deleteObject(with: "\(Support.baseUrl)/draft_orders/\(id).json") { [weak self] result in
            print(result?.localizedDescription ?? "no error")
            self?.getCardDraftOrder()
        }
    }
    
}
