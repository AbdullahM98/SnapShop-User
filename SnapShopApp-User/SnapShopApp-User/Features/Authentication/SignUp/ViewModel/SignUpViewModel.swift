//
//  SignUpViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import Foundation
import Combine
import SwiftUI


class SignUpViewModel: ObservableObject{
    
    @Published var emailField : FieldModel = FieldModel(value: "",  fieldType: .email)
    @Published var passwordField : FieldModel = FieldModel(value: "",  fieldType: .password)
    @Published var firstNameField : FieldModel = FieldModel(value: "",  fieldType: .firstName)
    @Published var lastNameField : FieldModel = FieldModel(value: "",  fieldType: .lastName)
    @Published var confirmPasswordField : FieldModel = FieldModel(value: "",  fieldType: .confirmPass)
    @Published var phNoField : FieldModel = FieldModel(value: "",  fieldType: .phoneNum)
    @Published var cityField : FieldModel = FieldModel(value: "",  fieldType: .city)
    @Published var countryField : FieldModel = FieldModel(value: "",  fieldType: .country)
    @Published var addressField : FieldModel = FieldModel(value: "",  fieldType: .address)
    @Published var isLoggedIn = false
    @Published var errorMessage: String = ""
    @Published var customer :Customer?
    @Published var signUpResponse:authResponse?
    @Published var selectedCountry: CountryCode = .Egypt
    @Published var viewState: SignUpViewState = .active

    private var cancellables = Set<AnyCancellable>()
    private var networkServices : NetworkService?
    private var firebaseManager : AuthenticationProtocol?
  
    init(networkServices : NetworkService ,firebaseManager : AuthenticationProtocol){
        self.networkServices = networkServices
        self.firebaseManager = firebaseManager
    }

    func postCustomer(customer:Customer) {
           networkServices?.postCustomer(customer)
              .sink(receiveCompletion: { [weak self] completion in
                   switch completion {
                   case.finished:
                       break
                   case.failure(let error):
                       DispatchQueue.main.async {
                           self?.handleError(error)
                           self?.viewState = .active
                           SnackBarHelper.showSnackBar(message: "Register failed", color: Color.white)

                       }
                     
                   }
               }, receiveValue: {  response in
                   DispatchQueue.main.async {
                    self.signUpResponse = response
                       self.isLoggedIn = true
                       self.viewState = .active
                       self.saveUserId(signUpResponse: response)
                       SnackBarHelper.showSnackBar(message: "Registered Succefully", color: Color.white)
                    }
                   
               })
              .store(in: &cancellables)
       }

    
    
    func register(customer:  Customer) {
        self.viewState = .loading
        firebaseManager?.registerUser(email: customer.email!, password: customer.password!) { [weak self] success, userId , error in
              if let error = error {
                  DispatchQueue.main.async {
                      self?.errorMessage = error.localizedDescription
                      SnackBarHelper.showSnackBar(message: "Register Failed , Try Again", color: Color.white)
                      self?.viewState = .active
                  }
              } else {
                  print("posting \(customer.email!)")
                  print("posting \(customer.password!)")
                  print("posting \(customer.first_name!)")
                  print("posting \(customer.last_name)")
                  self?.postCustomer(customer: (self?.customer)!)
              }
          }
      }
    
     func saveUserId(signUpResponse:authResponse){
        
        UserDefaultsManager.shared.setUserId(key: Support.userID, value: signUpResponse.customer.id)
        UserDefaultsManager.shared.setIsloggedIn(key: Support.isLoggedUDKey, value: true)
        print("from ud\(UserDefaultsManager.shared.getUserId(key: Support.userID)?.description ?? "No" )")
    }
    
    private func handleError(_ error: Error) {
        if let error = error as? DecodingError {
            errorMessage = "Decoding error: \(error)"
        } else {
            errorMessage = "Unknown error: \(error.localizedDescription)"
        }
    }
    
//    
//    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
//        if let error = error {
//            print(error.localizedDescription)
//            return
//        }
//        guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
//        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
//        Auth.auth().signIn(with: credential) { [weak self] (_, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else {
//                self?.state =.signedIn
//            }
//        }
//    }
}
