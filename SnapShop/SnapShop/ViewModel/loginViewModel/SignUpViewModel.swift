//
//  SignUpViewModel.swift
//  SnapShop
//
//  Created by Abdullah Essam on 02/06/2024.
//

import Foundation

import Combine

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
    private var customer :Customer?
    private var cancellables = Set<AnyCancellable>()
    
    
    func register(customer:  Customer) {
        FirebaseManager.shared.registerUser(email: customer.email, password: customer.password) { [weak self] success, userId , error in
              if let error = error {
                  DispatchQueue.main.async {
                      self?.errorMessage = error.localizedDescription
                  }
              } else {
                  self?.isLoggedIn = true
                  self?.customer = customer
                  
                  self?.addCustomer(customer: customer)
              }
          }
      }
    
    func addCustomer(customer:Customer){
        
//        Network.shared.request("\(Support.baseUrl)/customers.json", method: "POST",requestBody: CustomerRequest(customer: customer), responseType:CustomerResponse.self){ response in
//            print(">> \(response)")
//        }
       // Network.shared.sendPostRequest(customer:  customer)
    }
    
}
