//
//  OrdersViewModel.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import Foundation

class OrdersViewModel :ObservableObject{
    @Published var orderList : [Order] = []
    
    init() {
        fetchCompletedOrders()
        print("OrderVM INIT")
    }
    deinit {
        print("OrderVM DEINIT")
    }

    func fetchCompletedOrders() {
        guard let customerId = UserDefaultsManager.shared.getUserId(key: Support.userID) else { return }
        let url = "\(Support.baseUrl)/orders.json?customer_id=\(customerId)"
        
        Network.shared.request(url, method: "GET", responseType: OrderResponse.self) { [weak self] result in
            switch result {
            case .success(let orderResponse):
                DispatchQueue.main.async {
                    self?.orderList = orderResponse.orders ?? []
                    print("completed orders are ",orderResponse.orders?.count)
                }
            case .failure(let error):
                print("Error fetching orders: \(error)")
            }
        }
    }
}
