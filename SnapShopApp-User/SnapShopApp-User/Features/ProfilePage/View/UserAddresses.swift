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
    @ObservedObject var userData:ProfileViewModel = ProfileViewModel.shared
    
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(userData.addresses ?? [],id: \.id) { address in
                    AddressCell(address: address)
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
                AddAddress(onSaveClick: {
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
        UserAddresses()
    }
}
