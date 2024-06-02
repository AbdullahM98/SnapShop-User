//
//  LoginScreen.swift
//  SnapShop
//
//  Created by Abdullah Essam on 02/06/2024.
//

import SwiftUI


struct LoginScreen: View {
    @State private var text: String = ""
    @StateObject var viewModel:LoginViewModel
    var body: some View {
        VStack{
            Spacer()
            
            AppTextField(fieldModel: $viewModel.emailField).onSubmit {
                viewModel.emailField.onSubmitError()
            }
            
            AppTextField(fieldModel: $viewModel.passwordField).onSubmit {
                viewModel.passwordField.onSubmitError()
            }
            
            HStack{
                Spacer()
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Forgot Password?").font(.footnote).fontWeight(.medium).underline().foregroundStyle(Color.gray)
                }).padding(.trailing,10)
                
            }.padding(.bottom,180)
            
            AppButton(text: "Login", width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05, bgColor: Color.black,isFilled: true).padding(.bottom,50)
                      
                      
        }.padding(.all,20)
    }
}

#Preview {
    LoginScreen( viewModel: LoginViewModel())
}
