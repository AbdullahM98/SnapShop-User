//
//  OrdersViewModel.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import Foundation

// MARK: - OrdersViewModel

class OrdersViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var orderList: [Order] = []
    
    // MARK: - Initializers
    
    init() {
        fetchCompletedOrders()
    }

    // MARK: - Data Fetching Methods
    
    /// Fetches completed orders for the current customer.
    func fetchCompletedOrders() {
        guard let customerId = UserDefaultsManager.shared.getUserId(key: Support.userID) else {
            return
        }
        
        let url = "\(Support.baseUrl)/orders.json?customer_id=\(customerId)"
        
        Network.shared.request(url, method: "GET", responseType: OrderResponse.self) { [weak self] result in
            switch result {
            case .success(let orderResponse):
                DispatchQueue.main.async {
                    self?.orderList = orderResponse.orders ?? []
                }
            case .failure:
                break
            }
        }
    }
}
