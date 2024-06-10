//
//  ProfileViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: CustomerProfileDetails?
    @Published var isLoading: Bool = true
    init() {
        print("PVM INIT")
    }
    deinit {
        print("PVM DEINIT")
    }
    
    func fetchUserById(id: String) {
        let url = "\(Support.baseUrl)/customers/\(id).json"
        Network.shared.request(url, method: "GET", responseType: CustomerProfileRoot.self) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.user = user.customer
                }

            case .failure(let error):
                print("Error fetching user details: \(error)")
            }
        }
    }
    
    func updateUserData(user:CustomerUpdateRequest){
        let customerId = "7290794967219"
        Network.shared.updateData(object: user, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers/\(customerId).json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response.customer?.email)
                    self?.fetchUserById(id: customerId)
                    
                }
            case .failure(let error):
                print("Error updating user data: \(error)")
            }
        }
    }
    
   
    
}
