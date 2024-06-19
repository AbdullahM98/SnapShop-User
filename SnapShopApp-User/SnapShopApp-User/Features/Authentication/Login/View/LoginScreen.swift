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
    @StateObject var viewModel = LoginViewModel()
    @State private var navigateToHome = false
    @State private var navigateToRegister = false
    var body: some View {
        NavigationStack{
            if $viewModel.viewState.wrappedValue == .loginView {
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
                        
                    }.padding(.bottom,15)
                    
                    VStack{
                        Button(action:{
                            self.navigateToRegister = true
                        },label:{
                            Text("Don't have an account ? Register Now").font(.footnote).fontWeight(.medium).underline().foregroundStyle(Color.gray)
                    
                        }).padding(.bottom,10)
                        Button(action:{
                            navigateToHome = true
                        },label:{
                            Text("Continue as Guest").font(.footnote).fontWeight(.medium).underline().foregroundStyle(Color.gray)
                            
                        }).padding(.bottom,160)
                    }
                    
                    
                    AppButton(text: "Login", width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.05,isFilled: true , onClick: {
                        viewModel.login(email: text, password: password)
                        viewModel.viewState = .loading
                    }).padding(.bottom,50)
                    
                    
                }.navigationBarBackButtonHidden(true).padding(.all,20)
            }else{
                VStack {
                    Spacer()
                    CustomCircularProgress()
                    Spacer()
                }
            }
            
        }.onReceive(viewModel.$isLogIn){ _ in
            navigateToHome = true
        }
        .navigationDestination(isPresented:$navigateToHome){
            ContentView()
        } .navigationDestination(isPresented: $navigateToRegister){
             SignUpScreen()
         }
    }
    }


struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen( viewModel: LoginViewModel())
    }
}
