//
//  SettingsView.swift
//  SnapShopApp-User
//
//  Created by husayn on 12/06/2024.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var networkMonitor :NetworkMonitor
    @State private var selectedCurrency: String?
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.medium
    @StateObject var viewModel : ProfileViewModel = ProfileViewModel()
    @StateObject var orderViewModel : OrdersViewModel = OrdersViewModel()
    @StateObject var currenciesViewModel : CurrencyViewModel = CurrencyViewModel()
    @State private var navigateToUserAddresses = false // Flag to trigger navigation
    @State private var navigateToCurrencyView = false
    @State private var navigateToLogin = false
    @State private var navigateToRegister = false
    @State private var navigateToBase = false
    @State private var logoutAlert = false


    var body: some View {
        VStack {
            if $viewModel.viewState.wrappedValue == .loading {
                VStack {
                    Spacer()
                    CustomCircularProgress()
                    Spacer()
                }
            } 
            else  if $viewModel.viewState.wrappedValue == .userActive{
                
            VStack{
                    Form{
                        HStack{
                            Image("apple").resizable()
                                .frame(width: 48,height: 48)
                                .clipShape(Circle())
                            VStack(alignment: .leading){
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
                                },user: viewModel.user).presentationDetents([.medium], selection: $settingsDetents)
                            }
                        }
                        VStack(alignment: .leading){
                            Text("Current Address: \(viewModel.user?.addresses?.last?.city ?? ""), \(viewModel.user?.addresses?.last?.country ?? "").")
                                .lineLimit(1)
                                .padding(.vertical, 8)
                            Text("Phone Number: \(viewModel.user?.phone ?? "")")
                                .padding(.bottom, 8)
                        }
                        
                        //account section
                        Section(header: Text("Settings")){
                            NavigationLink(destination: UserOrders(orderList: orderViewModel.orderList)) {
                                
                                HStack{
                                    Text("Orders")
                                }
                            }
                            
                            NavigationLink(destination: UserAddresses(fromCart: false, didSelectAddress: {_ in}), isActive: $navigateToUserAddresses) {
                                HStack{
                                    Text("Addresses")
                                }
                                
                            }
                            HStack {
                                Text("Currency \(currenciesViewModel.selectedCurrencyCode ?? "USD")")
                                    
                                Spacer()
                                NavigationLink(
                                    destination: CurrencyView(viewModel: currenciesViewModel),
                                    isActive: $navigateToCurrencyView,
                                    label: {
                                        EmptyView()
                                    }
                                )// Ensure the button style doesn't interfere with the action
                            }
                        }
                        //Plicy section
                        Section(header: Text("Support")){
                            NavigationLink(destination: AboutUs()) {
                                HStack{
                                    Text("About Us")
                                }
                            }
                        }
                        Section(header: Text("POLICY")){
                            
                            
                            HStack{
                                Image(systemName:"gear")
                                Text("Version")
                                Spacer()
                                Text("1.0.0").foregroundColor(.gray)
                            }
                        }
                        Section(header:Text("Account")){
                            HStack{
                                
                                Button(
                                    action: {
                                        logoutAlert = true
                                    }) {
                                        
                                        Text("Log out")
                                            .foregroundColor(.red)
                                            .bold()
                                    }.alert(isPresented: $logoutAlert) {
                                        Alert(
                                            title: Text("LogOut!!"),
                                            message: Text("Are you sure to logout?"),
                                            primaryButton: .destructive(Text("Logout"), action: {
                                                UserDefaultsManager.shared.hasDraft = false
                                                UserDefaultsManager.shared.notifyCart = 0
                                                UserDefaultsManager.shared.userDraftId = 0
                                                UserDefaultsManager.shared.setUserId(key: Support.userID, value: 0)
                                                viewModel.logout()
                                                navigateToBase = true
                                                logoutAlert = false
                                                
                                            }),
                                            secondaryButton: .cancel(Text("Cancel"), action: {
                                                logoutAlert = false
                                            })
                                        )
                                    }
                            }

                        }
                    }
                }
            } else {
                VStack(alignment:.center){
                    Image("not_verified").resizable().padding(.top,50).frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.3)
                    Text("You are not logged in ").padding(.top,20).font(.title3)
                    Text("Please login to continue ").font(.title3).fontWeight(.semibold)
               
                    AppButton(text: "Login", width: UIScreen.screenWidth*0.8, height: UIScreen.screenHeight*0.05, isFilled: true, onClick: {
                        self.navigateToLogin = true
                    }).padding(.top , 170)
                    
                    AppButton(text: "SignUp", width: UIScreen.screenWidth*0.8, height: UIScreen.screenHeight*0.05, isFilled: false, onClick: {
                        self.navigateToRegister = true
                    }).padding(.top , 10)
                }
            }
            
        }
        .padding(.bottom,60)
        .onAppear {
           
            if viewModel.isUserValidated() {
                viewModel.viewState = .loading
                viewModel.fetchUserById()
            }else{
                viewModel.viewState = .userInActive
            }
        }
        .navigationDestination(isPresented:$navigateToLogin ){
            LoginScreen()
        }.navigationDestination(isPresented: $navigateToRegister){
            SignUpScreen()
        }.navigationDestination(isPresented: $navigateToBase){
            BaseView()
        }
    }
}
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView()
        }
    }
    
