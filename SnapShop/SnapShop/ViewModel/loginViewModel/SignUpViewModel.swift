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
    @Published var phNoField : FieldModel = FieldModel(value: "Phone no.",  fieldType: .def)
    @Published var cityField : FieldModel = FieldModel(value: "City",  fieldType: .def)
    @Published var countryField : FieldModel = FieldModel(value: "Country",  fieldType: .def)
    @Published var addressField : FieldModel = FieldModel(value: "Address",  fieldType: .def)
    @Published var isLoggedIn = false
    @Published var errorMessage: String = ""
    private var cancellables = Set<AnyCancellable>()
    
    
    func register(email: String, password: String) {
          FirebaseManager.shared.registerUser(email: email, password: password) { success, error in
              if let error = error {
                  DispatchQueue.main.async {
                      self.errorMessage = error.localizedDescription
                  }
              } else {
                  self.isLoggedIn = true
              }
          }
      }
}
