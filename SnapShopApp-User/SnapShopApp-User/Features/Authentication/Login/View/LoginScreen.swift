//
//  LoginScreen.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import SwiftUI

struct LoginScreen: View {
    @State private var text: String = ""
    @State private var password: String = ""
    @StateObject var viewModel:LoginViewModel
    var body: some View {
        VStack{
            Spacer()
            
            AppTextField(fieldModel: $viewModel.emailField ,text: $text).onSubmit {
                viewModel.emailField.onSubmitError()
            }
            
            AppTextField(fieldModel: $viewModel.passwordField , text: $password).onSubmit {
                viewModel.passwordField.onSubmitError()
            }
            
            HStack{
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Forgot Password?").font(.footnote).fontWeight(.medium).underline().foregroundStyle(Color.gray)
                }).padding(.trailing,10)
              
            }.padding(.bottom,180)
            
            
            AppButton(text: "Login", width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05,isFilled: true , onClick: {
                viewModel.login(email: text, password: password)
            }).padding(.bottom,50)
                      
                      
        }.padding(.all,20)
    }
}

#Preview {
    LoginScreen( viewModel: LoginViewModel())
}
