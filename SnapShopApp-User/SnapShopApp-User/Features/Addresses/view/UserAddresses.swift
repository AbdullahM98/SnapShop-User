//
//  UserAdresses.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct UserAddresses: View {
    @State private var viewModel = AddressesViewModel()
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.medium
    var fromCart: Bool
    @Environment(\.presentationMode) var presentationMode
    var didSelectAddress: ((AddressProfileDetails) -> Void)? // Closure to be called when an address is selected
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(viewModel.addresses ?? [],id: \.id) { address in
                    AddressCell(address: address, insideCard: false, onDeleteClick: {
                        viewModel.deleteAddress(addressId: address.id ?? 0)
                    }).onTapGesture {
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
                    AddAddress(onSaveClick: {address in
                        viewModel.postUserAddress(address: address)
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
        UserAddresses(fromCart: false)
    }
}
