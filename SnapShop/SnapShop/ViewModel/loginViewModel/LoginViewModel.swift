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
        FirebaseManager.shared.login(email: email, password: password) { success, error in
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
