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
    @ObservedObject var viewModel = ProfileViewModel.shared
    @State var userDetails: CustomerDetails?
    @State private var navigateToUserAddresses = false // Flag to trigger navigation
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    HStack {
                        Image("car")
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
                            ProfileEdit().presentationDetents([.medium], selection: $settingsDetents)
                        }
                    }
                    Rectangle()
                        .frame(height: 0.3)
                        .padding(.bottom, 8)
                        .foregroundColor(.gray)
                    Text("Current Address: \(viewModel.user?.addresses?.first?.city ?? ""), \(viewModel.user?.addresses?.first?.country ?? "").")
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
                    .padding(.all, 16)
                
                Button(action: {
                    // Handle My Orders
                }) {
                    Image("bag")
                    Text("My Orders")
                        .foregroundColor(.black)
                }
                .padding(.all, 16)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                
                NavigationLink(destination: UserAddresses(), isActive: $navigateToUserAddresses) {
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
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
