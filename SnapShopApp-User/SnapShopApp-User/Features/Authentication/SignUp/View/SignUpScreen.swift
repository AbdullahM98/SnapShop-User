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
    @State var address :String = ""
    @State private var navigateToHome = false
   
    var body: some View {
        
        NavigationView {
       
                        
                        VStack{
                            Text("Register").padding(.vertical,30).font(.title3)
                            AppTextField(fieldModel: $viewModel.firstNameField , text: $firstName)
                            
                            AppTextField(fieldModel: $viewModel.lastNameField , text: $lastName)
                            
                            AppTextField(fieldModel: $viewModel.emailField , text: $email)
                            
                            AppTextField(fieldModel: $viewModel.passwordField , text: $password)
                            
                            AppTextField(fieldModel: $viewModel.confirmPasswordField, text: $confirmPassword, compareTo: password)
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
                            
                            AppTextField(fieldModel: $viewModel.addressField , text: $address)
                            
                            AppButton(text: "SignUp", width: UIScreen.screenWidth * 0.95, height: UIScreen.screenHeight * 0.055,isFilled: true , onClick: {
                                let addressObj = Address(
                                                          phone: phNo,
                                                          country: viewModel.selectedCountry.rawValue,
                                                          province: "",
                                                          zip: "",
                                                          address1: viewModel.addressField.value,
                                                          first_name: viewModel.firstNameField.value,
                                                          last_name:  viewModel.lastNameField.value,
                                                          city: viewModel.cityField.value
                                                      )
                                                      let customer = Customer(
                                                        password_confirmation: confirmPassword,
                                                        phone: viewModel.phNoField.value,
                                                        password: password,
                                                        last_name: viewModel.lastNameField.value,
                                                          send_email_welcome: false,
                                                          verified_email: true,
                                                          addresses: [addressObj],
                                                          email: viewModel.emailField.value,
                                                        first_name: viewModel.firstNameField.value
                                                      )
                                print(" >>>>>>>>>>>> customer email is  \(customer.password) \(customer.password_confirmation) \(customer.last_name)")
                                viewModel.customer = customer
                                viewModel.register(customer: customer)
                                navigateToHome = true
                               
                            }).padding(.top,50)
                            
                            
                            
                            
                        }.padding(.all,10).navigationDestination(isPresented: $navigateToHome){
                            ContentView()
                        }
                    }
                    
      
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}

