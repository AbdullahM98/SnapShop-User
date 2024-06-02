//
//  SignUpScreen.swift
//  SnapShop
//
//  Created by Abdullah Essam on 02/06/2024.
//

import SwiftUI

struct SignUpScreen: View {
    @StateObject var viewModel:SignUpViewModel
    @State var email:String = ""
    @State var password :String = ""
    @State var phNo :String = ""
    @State var country :String = ""
    @State var city :String = ""
    @State var adddress :String = ""
    var body: some View {
        
       
            VStack{
                Text("SignUp").font(.title).bold().padding(.bottom,100)
                AppTextField(fieldModel: $viewModel.emailField , text: $email).onSubmit {
                    viewModel.emailField.onSubmitError()
                }
                AppTextField(fieldModel: $viewModel.passwordField , text: $password).onSubmit {
                    viewModel.passwordField.onSubmitError()
                }
                AppTextField(fieldModel: $viewModel.phNoField ,text: $phNo).onSubmit {
                    viewModel.phNoField.onSubmitError()
                }
                
                HStack{
                    AppTextField(fieldModel: $viewModel.countryField , text: $country).onSubmit {
                        viewModel.countryField.onSubmitError()
                    }
                    AppTextField(fieldModel: $viewModel.cityField ,text: $city).onSubmit {
                        viewModel.cityField.onSubmitError()
                    }
                
                }
                
                AppTextField(fieldModel: $viewModel.addressField , text: $adddress).onSubmit {
                    viewModel.addressField.onSubmitError()
                }
                AppButton(text: "SignUp", width: UIScreen.screenWidth * 0.95, height: UIScreen.screenHeight * 0.055,isFilled: true , onClick: {
                    viewModel.register(email: $email.wrappedValue, password: $password.wrappedValue)
                }).padding(.top,100)
            }.padding(.all,10)
        
    }
}

#Preview {
    SignUpScreen(viewModel: SignUpViewModel())
}
