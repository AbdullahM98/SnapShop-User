//
//  PofileView.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//


import SwiftUI

struct ProfileView: View {
    @State private var selectedCurrency: String?
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.medium
    @ObservedObject var viewModel : ProfileViewModel = ProfileViewModel()
    @ObservedObject var addressViewModel : AddressesViewModel = AddressesViewModel()
    @ObservedObject var orderViewModel : OrdersViewModel = OrdersViewModel()
    @ObservedObject var currenciesViewModel : CurrencyViewModel = CurrencyViewModel()
    @State var userDetails: CustomerProfileDetails?
    @State private var navigateToUserAddresses = false // Flag to trigger navigation
    @State private var navigateToCurrencyView = false
    @State private var navigateToLogin = false
    
    
    var body: some View {
        VStack {
            if $viewModel.viewState.wrappedValue == .loading {
                VStack {
                    Spacer()
                    CustomCircularProgress()
                    Spacer()
                }
            } else  if $viewModel.viewState.wrappedValue == .userActive{
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
                                Image("apple")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text("\(viewModel.user?.first_name ?? "") \(viewModel.user?.last_name ?? "")")
                                        .font(.title2)
                                    Text(viewModel.user?.email ?? "")
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                        .fontWeight(.light)
                                }
                                Spacer()
                                Button(action: {
                                    showingBottomSheet.toggle()
                                }) {
                                    Image("e")
                                }
                                .sheet(isPresented: $showingBottomSheet) {
                                    ProfileEdit(onSaveClick: { customer in
                                        showingBottomSheet.toggle()
                                        viewModel.updateUserData(user: customer)
                                    }, onCancelClick: {
                                        showingBottomSheet.toggle()
                                    }, user: viewModel.user).presentationDetents([.medium], selection: $settingsDetents)
                                }
                            }
                            Rectangle()
                                .frame(height: 0.3)
                                .padding(.bottom, 8)
                                .foregroundColor(.gray)
                            Text("Current Address: \(viewModel.user?.addresses?.last?.city ?? ""), \(viewModel.user?.addresses?.last?.country ?? "").")
                                .lineLimit(1)
                                .padding(.vertical, 8)
                            Text("Phone Number: \(viewModel.user?.phone ?? "")")
                                .padding(.bottom, 8)
                        }
                        .padding(.all, 12)
                    }
                    .border(Color.gray, width: 1)
                    .padding(.all, 12)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Currency Code -> \(currenciesViewModel.selectedCurrencyCode ?? "USD") ->  \(currenciesViewModel.selectedCurrencyValue ?? "1")")
                                .padding(.leading, 8)
                            Spacer()
                            NavigationLink(
                                destination: CurrencyView(viewModel: currenciesViewModel),
                                isActive: $navigateToCurrencyView,
                                label: {
                                    EmptyView()
                                }
                            )
                            Button(action: {
                                navigateToCurrencyView = true
                            }) {
                                Image(systemName: "arrow.right.circle")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(PlainButtonStyle()) // Ensure the button style doesn't interfere with the action
                        }
                        .contentShape(Rectangle()) // Make the entire row tappable
                        .padding()
                        .background(Color(UIColor.systemGroupedBackground)) // Optional styling
                        .cornerRadius(10)
                        .shadow(radius: 1)
                        .padding(.horizontal)
                        
                        
                        Text("More Tools")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.all, 8)
                        
                        NavigationLink(destination: UserOrders(orderList: orderViewModel.orderList)) {
                            HStack {
                                Image("bag")
                                Text("My Orders")
                                    .foregroundColor(.black)
                            }
                            .padding(.all, 16)
                        }
                        
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: UserAddresses(viewModel: addressViewModel, fromCart: false), isActive: $navigateToUserAddresses) {
                            Button(action: {
                                navigateToUserAddresses = true // Activate navigation
                            }) {
                                Image("bag")
                                Text("Addresses")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.all, 16)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            viewModel.logout()
                            navigateToLogin = true
                        }) {
                            Image("bag")
                            Text("Log out")
                                .foregroundColor(.black)
                        }
                        .padding(.all, 16)
                    }
                    .padding(.all, 8)
                    
                    Spacer()
                }
                
            } else{
                VStack(alignment:.center){
                    Image("not_verified").resizable().padding(.top,50).frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.3)
                    Text("You are not logged in ").padding(.top,20).font(.title3)
                    Text("Please login to continue ").font(.title3).fontWeight(.semibold)
               
                    AppButton(text: "Login", width: UIScreen.screenWidth*0.8, height: UIScreen.screenHeight*0.05, isFilled: true, onClick: {
                        self.navigateToLogin = true
                    }).padding(.top , 170)
                    
                    AppButton(text: "SignUp", width: UIScreen.screenWidth*0.8, height: UIScreen.screenHeight*0.05, isFilled: false, onClick: {
                        
                    }).padding(.top , 10)
                }
            }
        }.onAppear {
           
          //  viewModel.fetchUserById(id: "7290794967219")
            //orderViewModel.fetchCompletedOrders(customerId: "7290794967219")
            if viewModel.isUserValidated() {
                viewModel.viewState = .loading
                viewModel.fetchUserById()
            }else{
                viewModel.viewState = .userInActive
            }
        }
        .background(
            NavigationLink(destination: LoginScreen(), isActive: $navigateToLogin) {
                EmptyView()
            }
            .hidden().navigationBarBackButtonHidden(true) // Hide the navigation link
        )
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
