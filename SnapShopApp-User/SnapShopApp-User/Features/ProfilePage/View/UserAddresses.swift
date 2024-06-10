//
//  UserAdresses.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct UserAddresses: View {
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.medium
    @ObservedObject var userData:ProfileViewModel
    var fromCart: Bool
    @Environment(\.presentationMode) var presentationMode
    var didSelectAddress: ((AddressProfileDetails) -> Void)? // Closure to be called when an address is selected

    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(userData.addresses ?? [],id: \.id) { address in
                    AddressCell(address: address,viewModel: userData,insideCard: false).onTapGesture {
                        if fromCart == true {
                            print(address)
                            didSelectAddress?(address)
                            presentationMode.wrappedValue.dismiss() // Dismiss the second view

                        }
                    }
                }
            }
            .navigationBarTitle("Addresses")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton(),trailing: Button(action: {
                showingBottomSheet.toggle()
            }) {
                Image(systemName:"plus.circle.fill").foregroundColor(.black)
            }
            .sheet(isPresented: $showingBottomSheet) {
                AddAddress(userData: userData,onSaveClick: {
                    userData.postUserAddress()
                    showingBottomSheet.toggle()
                }, onCancelClick: {
                    showingBottomSheet.toggle()
                }).presentationDetents([.medium], selection: $settingsDetents)
            })
        }
    }
}

struct UserAddresses_Previews: PreviewProvider {
    static var previews: some View {
        UserAddresses(userData:ProfileViewModel(),fromCart: false)
    }
}
