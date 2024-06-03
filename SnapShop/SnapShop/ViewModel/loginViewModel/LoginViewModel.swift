//
//  LoginViewModel.swift
//  SnapShop
//
//  Created by Abdullah Essam on 02/06/2024.
//

import Foundation
class LoginViewModel : ObservableObject {
    @Published var emailField : FieldModel = FieldModel(value: "",  fieldType: .email)
    @Published var passwordField : FieldModel = FieldModel(value: "",  fieldType: .password)
    @Published var isLoggedIn = false
    
    @Published var errorMessage: String = ""
    
    func login(email: String, password: String) {
        print("logging in ")
        FirebaseManager.shared.login(email: email, password: password) { success, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            } else {
                self.getUsers(email: email)
            }
        }
    }
    
    func getUsers(email: String) {
        print("getting Users")
        Network.shared.request("\(Support.baseUrl)/customers.json", method: "GET", responseType: CustomersList.self) { result in
            switch result {
            case .success(let customersList):
                // Call another function with the obtained customer list
                DispatchQueue.main.async {
                           // Call another function with the obtained customer list
                           if self.isUserExists(email: email, customers: customersList.customers) {
                               self.isLoggedIn = true
                           }
                       }
            case .failure(let error):
                print("Error fetching customers: \(error)")
            }
        }
    }
    
    func isUserExists(email:String , customers : [Customers]) -> Bool{
        for customer in customers {
            print("\(customer.email)")
            if customer.email == email {
                print("user found")
                return true
            }
        }
        print("user not found")
        return false
    }
}
