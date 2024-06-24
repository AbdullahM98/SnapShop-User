//
//  LoginViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import Foundation
import GoogleSignIn
import FirebaseCore
import FirebaseAuth
import SwiftUI
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
                    UserDefaultsManager.shared.notifyCart = 0 
                    self.viewState = .loginView
                    SnackBarHelper.showSnackBar(message: "Couldn't sign in , Please try again", color: Color.red)
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
                    }else{
                        DispatchQueue.main.async{
                            self.viewState = .loginView
                            SnackBarHelper.showSnackBar(message: "Couldn't sign in , Please try again", color: Color.red)

                        }
                    }
                       }
            case .failure(let error):
                print("Error fetching customers: \(error)")
                DispatchQueue.main.async{
                    self.viewState = .loginView
                    SnackBarHelper.showSnackBar(message: "Couldn't sign in , Please try again", color: Color.red)

                }
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
    
    func signInWithGoogle() {
           guard let clientID = FirebaseApp.app()?.options.clientID else { return }
           
           // Create Google Sign In configuration object.
           let config = GIDConfiguration(clientID: clientID)
           GIDSignIn.sharedInstance.configuration = config

           // Get the root view controller for presenting the sign-in flow
           guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                 let rootViewController = windowScene.windows.first?.rootViewController else { return }

           // Start the sign-in flow
           GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
               guard error == nil else {
                   self?.errorMessage = error?.localizedDescription ?? "Error Signing in with Google"
                   return
               }

               FirebaseManager.shared.signInWithGoogle(result: result) { success, error in
                   if success {
                      
                       if let user = Auth.auth().currentUser {
                           UserDefaults.standard.setValue(user.uid, forKey: Support.fireBaseUserID)
                           self?.getUsers(email: user.email ?? "no")
                       }
                   } else {
                       self?.errorMessage = error?.localizedDescription ?? " error with google"
                       print(error?.localizedDescription ?? " error with google")
                       SnackBarHelper.showSnackBar(message: "Error logging with Google", color: Color.red)
                   }
               }
           }
       }

    

}

enum LoginViewState {
    
    case loginView
    case loading
}
