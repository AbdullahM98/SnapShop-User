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
    @State var userDetails: CustomerProfileDetails?
    @State private var navigateToUserAddresses = false // Flag to trigger navigation
    
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                VStack{
                    Spacer()
                    CustomCircularProgress()
                    Spacer()
                }
            }else{
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
                                    },user: viewModel.user).presentationDetents([.medium], selection: $settingsDetents)
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
                        Text("Currency Code")
                            .padding(.leading, 8)
                        
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
                        
                        NavigationLink(destination: UserAddresses(viewModel: addressViewModel,fromCart: false), isActive: $navigateToUserAddresses) {
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
                            // Handle Log out
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
                
            }
        }.onAppear{
            viewModel.fetchUserById(id: "7290794967219")
            orderViewModel.fetchCompletedOrders(customerId: "7290794967219")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
