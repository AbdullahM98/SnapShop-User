//
//  SignUpViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
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
    @Published var customer :Customer?
    private var cancellables = Set<AnyCancellable>()
  

    func postCustomer(customer:Customer) {
           Network.shared.requestFromApi(customer)
              .sink(receiveCompletion: { [weak self] completion in
                   switch completion {
                   case.finished:
                       break
                   case.failure(let error):
                       DispatchQueue.main.async {
                           self?.handleError(error)
                       }
                     
                   }
               }, receiveValue: { [weak self] customer in
                   self?.customer = customer
                   
               })
              .store(in: &cancellables)
       }

    
    
    func register(customer:  Customer) {
        FirebaseManager.shared.registerUser(email: customer.email!, password: customer.password!) { [weak self] success, userId , error in
              if let error = error {
                  DispatchQueue.main.async {
                      self?.errorMessage = error.localizedDescription
                  }
              } else {
                  self?.isLoggedIn = true
                  
                  print("posting \(customer.email!)")
                  print("posting \(customer.password!)")
                  print("posting \(customer.first_name!)")
                  print("posting \(customer.last_name)")
                  self?.postCustomer(customer: (self?.customer)!)
              }
          }
      }
    
    private func handleError(_ error: Error) {
        if let error = error as? DecodingError {
            errorMessage = "Decoding error: \(error)"
        } else {
            errorMessage = "Unknown error: \(error.localizedDescription)"
        }
    }
    
}
