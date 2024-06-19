//
//  SignUpScreen.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import SwiftUI

struct SignUpScreen: View {
    @StateObject var viewModel:SignUpViewModel = SignUpViewModel()
    @State var email:String = ""
    @State var password :String = ""
    @State var firstName:String = ""
    @State var lastName :String = ""
    @State var confirmPassword :String = ""
    @State var phNo :String = ""
    @State var country :String = ""
    @State var city :String = ""
    @State var adddress :String = ""
    var body: some View {
        
        NavigationView {
        if viewModel.isLoggedIn {
                      //  HomeView()
                    } else {
                        
                        VStack{
                            Text($viewModel.errorMessage.wrappedValue).font(.title).bold().padding(.bottom,50)
                            AppTextField(fieldModel: $viewModel.firstNameField , text: $firstName)
                            
                            AppTextField(fieldModel: $viewModel.lastNameField , text: $lastName)
                            
                            AppTextField(fieldModel: $viewModel.emailField , text: $email)
                            
                            AppTextField(fieldModel: $viewModel.passwordField , text: $password)
                            
                            AppTextField(fieldModel: $viewModel.confirmPasswordField , text: $confirmPassword)
                            AppTextField(fieldModel: $viewModel.phNoField ,text: $phNo)
                            
                            HStack(spacing:30){
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black, lineWidth: 1.3).opacity(0.3)
                                              .frame(height: UIScreen.screenHeight * 0.0499)
                                              .overlay(
                                                Picker("Country", selection: $viewModel.selectedCountry) {
                                                      ForEach(CountryCode.allCases) { country in
                                                          Text(country.countryName).tag(country)
                                                              .foregroundStyle(Color.black)
                                                      }
                                                  }
                                                    .pickerStyle(MenuPickerStyle())
                                                  
                                              )
                                
                                
                                AppTextField(fieldModel: $viewModel.cityField ,text: $city).padding(.top,6)
                                
                            }
                            
                            AppTextField(fieldModel: $viewModel.addressField , text: $adddress)
                            
                            AppButton(text: "SignUp", width: UIScreen.screenWidth * 0.95, height: UIScreen.screenHeight * 0.055,isFilled: true , onClick: {
                                let address = Address(phone: $phNo.wrappedValue, country: viewModel.selectedCountry.rawValue, province: "", zip: "", address1: $adddress.wrappedValue, first_name: $firstName.wrappedValue, last_name: $lastName.wrappedValue, city: $city.wrappedValue)
                                var customer = Customer(password_confirmation: $password.wrappedValue,  phone: $phNo.wrappedValue, password: $password.wrappedValue, last_name: $lastName.wrappedValue, send_email_welcome: false, verified_email: true, addresses: [address], email:$email.wrappedValue, first_name: $firstName.wrappedValue)
                                
                                viewModel.customer = customer
                               viewModel.register(customer: customer)
                               
                            }).padding(.top,50)
                            
                            
                            
                            
                        }.padding(.all,10)
                    }
                    }
      
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen(viewModel: SignUpViewModel())
    }
}

