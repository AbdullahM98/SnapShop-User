//
//  LoginViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import Foundation

class LoginViewModel : ObservableObject {
    @Published var emailField : FieldModel = FieldModel(value: "",  fieldType: .email)
    @Published var passwordField : FieldModel = FieldModel(value: "",  fieldType: .password)
    @Published var isLogIn = false
    
    @Published var errorMessage: String = ""
    
    func login(email: String, password: String) {
        print("logging in ")
        FirebaseManager.shared.login(email: email.lowercased(), password: password) { success, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
            } else {
                self.getUsers(email: email.lowercased())
            }
        }
    }
    
    func getUsers(email: String) {
        print("getting Users")
        Network.shared.request("\(Support.baseUrl)/customers.json", method: "GET", responseType: CustomerList.self) { result in
            switch result {
            case .success(let customersList):
             
                DispatchQueue.main.async {
                         if self.isUserExists(email: email, customers: customersList.customers).0 {
                               self.isLogIn = true
                             self.setISLoggedIn(isLogged: true)
                               self.saveUserData(customer: self.isUserExists(email: email, customers: customersList.customers).1 ?? Customer(phone: "", password: "", last_name: "", addresses: [], email: "", first_name: ""))
                           }
                       }
            case .failure(let error):
                print("Error fetching customers: \(error)")
            }
        }
    }
    
    func isUserExists(email:String , customers : [Customer]) -> (Bool,Customer?){
        for customer in customers {
            print("\(customer.email!)")
            if customer.email! == email {
                print("user found")
                return (true,customer)
            }
        }
        
        print("user not found")
        return (false,nil)
    }
    func isLoggedIn() ->Bool{
       return UserDefaultsManager.shared.getDynamicValue(key: Support.isLoggedUDKey) ?? isLogIn
    }
    
    func setISLoggedIn(isLogged :Bool) {
        UserDefaultsManager.shared.setDynamicValue(key: Support.isLoggedUDKey, value: isLogged)
    }
    func fetchCustomers() -> [Customer]{
        return AppCoreData.shared.fetchCustomers()
    }
    func saveUserData(customer:Customer){
        AppCoreData.shared.insertCustomer(customer: customer)
        
    }
}
