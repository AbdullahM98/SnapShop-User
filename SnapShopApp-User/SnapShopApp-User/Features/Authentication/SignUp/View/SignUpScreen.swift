import SwiftUI

struct SignUpScreen: View {
    @StateObject var viewModel: SignUpViewModel = SignUpViewModel()
    @State var email: String = ""
    @State var password: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var confirmPassword: String = ""
    @State var phNo: String = ""
    @State var country: String = ""
    @State var city: String = ""
    @State var address: String = ""
    @State private var navigateToHome = false

    private var isFormValid: Bool {
        !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && !firstName.isEmpty && !lastName.isEmpty &&
        !phNo.isEmpty && !city.isEmpty && !address.isEmpty
    }

    var body: some View {
        if viewModel.viewState == .loading {
            VStack {
                Spacer()
                CustomCircularProgress()
                Spacer()
            }
        }else  {
            NavigationView {
                VStack {
                    Text("Register").padding(.vertical, 30).font(.title3)
                    AppTextField(fieldModel: $viewModel.firstNameField, text: $firstName)
                    AppTextField(fieldModel: $viewModel.lastNameField, text: $lastName)
                    AppTextField(fieldModel: $viewModel.emailField, text: $email)
                    AppTextField(fieldModel: $viewModel.passwordField, text: $password)
                    AppTextField(fieldModel: $viewModel.confirmPasswordField, text: $confirmPassword, compareTo: password)
                    AppTextField(fieldModel: $viewModel.phNoField, text: $phNo)

                    HStack(spacing: 30) {
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.black, lineWidth: 1.3)
                            .opacity(0.3)
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

                        AppTextField(fieldModel: $viewModel.cityField, text: $city)
                            .padding(.top, 6)
                    }

                    AppTextField(fieldModel: $viewModel.addressField, text: $address)

                  

                    AppButton(
                        text: "SignUp",
                        width: UIScreen.screenWidth * 0.95,
                        height: UIScreen.screenHeight * 0.055,
                        isFilled: true,
                        onClick: {
                            let addressObj = Address(
                                phone: phNo,
                                country: viewModel.selectedCountry.rawValue,
                                province: "",
                                zip: "",
                                address1: address,
                                first_name: firstName,
                                last_name: lastName,
                                city: city
                            )

                            let customer = Customer(
                                password_confirmation: confirmPassword,
                                phone: phNo,
                                password: password,
                                last_name: lastName,
                                send_email_welcome: false,
                                verified_email: true,
                                addresses: [addressObj],
                                email: email,
                                first_name: firstName
                            )

                            print(" >>>>>>>>>>>> customer email is  \(customer.password) \(customer.password_confirmation) \(customer.last_name)")
                            viewModel.customer = customer
                            viewModel.register(customer: customer)
                        }
                    )
                    .disabled(!isFormValid)
                    .padding(.top, 50)
                    .onReceive(viewModel.$isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                        
                            navigateToHome = true
                            print("///////////////////////// \(navigateToHome)")
                        }
                    }
                    .background(
                                     NavigationLink(
                                         destination: ContentView(),
                                         isActive: $navigateToHome,
                                         label: { EmptyView() }
                                     )
                                 )
                }
                .padding(.all, 10)
            }
        }
    }
}

struct SignUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignUpScreen()
    }
}

enum SignUpViewState {
    case loading
    case active
}
