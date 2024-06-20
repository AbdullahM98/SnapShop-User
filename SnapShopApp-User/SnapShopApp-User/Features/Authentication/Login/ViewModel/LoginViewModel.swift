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
    @Published var viewState : LoginViewState?
    var userId : Int?
    @Published var errorMessage: String = ""
    
    init(){
        viewState = .loginView
    }
    
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
        Network.shared.request("\(Support.baseUrl)/customers.json", method: "GET", responseType: SignInResponse.self) { result in
            switch result {
            case .success(let responsesList):
             
                DispatchQueue.main.async {
                    if self.isUserExists(email: email, responses:responsesList.customers).0 {
                               self.isLogIn = true
                             self.setISLoggedIn(isLogged: true)
                      //  self.setISLoggedIn(isLogged: true)
                       
                        if let customerResponse = self.isUserExists(email: email, responses: responsesList.customers).1 {
                               self.saveUserId(authResponse: customerResponse)
                           }
                           }
                       }
            case .failure(let error):
                print("Error fetching customers: \(error)")
            }
        }
    }
    
    func isUserExists(email:String , responses : [CustomerAuthResponse]) -> (Bool,CustomerAuthResponse?){
        for customerResponse in responses {
            print("\(customerResponse.email)")
            if customerResponse.email == email {
                print("user found")
                return (true,customerResponse)
            }
        }
        
        print("user not found")
        return (false,nil)
    }
   
    
    func isLoggedIn() ->Bool{
       return UserDefaultsManager.shared.getIsloggedIn(key: Support.isLoggedUDKey) ?? isLogIn
    }
    
    private func saveUserId(authResponse:CustomerAuthResponse){
        self.userId = authResponse.id
        UserDefaultsManager.shared.setUserId(key: Support.userID, value: authResponse.id)
        
        print("from ud\(UserDefaultsManager.shared.getUserId(key: Support.userID)?.description ?? "No" )")
    }
    
    func setISLoggedIn(isLogged :Bool) {
        UserDefaultsManager.shared.setIsloggedIn(key: Support.isLoggedUDKey, value: isLogged)
    }

}

enum LoginViewState {
    
    case loginView
    case loading
}
