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
                        HomeView()
                    } else {
                        
                        VStack{
                            Text("SignUp").font(.title).bold().padding(.bottom,50)
                            AppTextField(fieldModel: $viewModel.firstNameField , text: $firstName).onSubmit {
                                viewModel.emailField.onSubmitError()
                            }
                            AppTextField(fieldModel: $viewModel.lastNameField , text: $lastName).onSubmit {
                                viewModel.emailField.onSubmitError()
                            }
                            AppTextField(fieldModel: $viewModel.emailField , text: $email).onSubmit {
                                viewModel.emailField.onSubmitError()
                            }
                            AppTextField(fieldModel: $viewModel.passwordField , text: $password).onSubmit {
                                viewModel.passwordField.onSubmitError()
                            }
                            AppTextField(fieldModel: $viewModel.confirmPasswordField , text: $confirmPassword).onSubmit {
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
                                let address = Address(phone: $phNo.wrappedValue, country: $country.wrappedValue, province: "", zip: "", address1: $adddress.wrappedValue, first_name: $firstName.wrappedValue, last_name: $lastName.wrappedValue, city: $city.wrappedValue)
//                                var customer = Customer(first_name: $firstName.wrappedValue, last_name: $lastName.wrappedValue, email: $email.wrappedValue, phone: $phNo.wrappedValue, verified_email: true, addresses: [address], password: $password.wrappedValue, password_confirmation: $confirmPassword.wrappedValue, send_email_welcome: false)
                                
//                                viewModel.register(customer: customer)
                                Network.shared.sendPostRequest()
                            }).padding(.top,50)
                            
                            
                            
                            
                        }.padding(.all,10)
                    }
                    }
      
    }
}

#Preview {
    SignUpScreen(viewModel: SignUpViewModel())
}
