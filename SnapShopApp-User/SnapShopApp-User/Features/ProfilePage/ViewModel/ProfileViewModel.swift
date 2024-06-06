//
//  ProfileViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: CustomerDetails?
    
    init() {
        fetchUserById(id: "7290794967219")
    }

    func fetchUserById(id: String) {
        let url = "\(Support.baseUrl)/customers/\(id).json"
        Network.shared.request(url, method: "GET", responseType: CustomerResponse.self) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.user = user.customer
                }
            case .failure(let error):
                print("Error fetching user details: \(error)")
            }
        }
    }
}
