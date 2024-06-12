//
//  ProfileViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var viewState: ProfileViewState
    @Published var user: CustomerProfileDetails?
    @Published var isLoading: Bool = true
    
    init() {
        print("PVM INIT")
        self.viewState = .loading
    }
    deinit {
        print("PVM DEINIT")
    }
    
    func fetchUserById() {
         let userId = UserDefaults.standard.integer(forKey: Support.userID)
        let url = "\(Support.baseUrl)/customers/\(userId).json"
        Network.shared.request(url, method: "GET", responseType: CustomerProfileRoot.self) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.isLoading = false
                    self?.viewState = .userActive
                    self?.user = user.customer
                }

            case .failure(let error):
                print("Error fetching user details: \(error)")
                DispatchQueue.main.async{
                    self?.viewState = .userInActive
                }
                
                
            }
        }
    }
    
    func updateUserData(user:CustomerUpdateRequest){
        let customerId = UserDefaults.standard.integer(forKey: Support.userID)
        Network.shared.updateData(object: user, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers/\(customerId).json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("\(response.customer?.email)")
                    self?.fetchUserById()
                    
                }
            case .failure(let error):
                print("Error updating user data: \(error)")
            }
        }
    }
    
    
    func logout(){
        FirebaseManager.shared.logout()
        UserDefaults.standard.set(false, forKey: Support.isLoggedUDKey)
    }
    func isUserValidated() -> Bool{
        guard let isLoggedIn = UserDefaults.standard.value(forKey: Support.isLoggedUDKey) else{
            return false
        }
      return isLoggedIn as! Bool
    }
    
}

enum ProfileViewState {
    case userInActive
    case userActive
    case loading
}
