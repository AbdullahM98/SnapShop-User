//
//  UserAdresses.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct UserAddresses: View {
    @ObservedObject var viewModel: AddressesViewModel = AddressesViewModel()
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.height(UIScreen.screenHeight*0.5 + 100)
    var fromCart: Bool
    @Environment(\.presentationMode) var presentationMode
    var didSelectAddress: (AddressProfileDetails) -> Void? // Closure to be called when an address is selected
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                Spacer()
                CustomCircularProgress()
                    .navigationBarTitle("Addresses")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: CustomBackButton())
                Spacer()
            }else{
                contentView
            }
        }.onAppear{
            viewModel.fetchUserAddresses()
        }
        
    }
    private var contentView: some View{
        VStack{
            ScrollView{
                ForEach(viewModel.addresses ?? [],id: \.id) { address in
                    AddressCell(address: address, fromCard: fromCart,
                                onDeleteClick: {
                        viewModel.deleteAddress(addressId: address.id ?? 0)
                    }, onUpdateClick: { updatedAddress in
                        viewModel.updateAddress(updatedAddress: updatedAddress, addressId: updatedAddress.customer_address?.id ?? 0)
                    }, onSelectClick: { selectedAddress in
                        print("SelectedAddress")
                        viewModel.updateUserShippingAddress(shippingAddress: selectedAddress)
                        didSelectAddress(selectedAddress)
                        presentationMode.wrappedValue.dismiss() // Dismiss the second view
                        return nil

                    })
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
                    }).presentationDetents([.height(UIScreen.screenHeight*0.5 + 100)], selection: $settingsDetents)
                })
        }.onAppear{
            viewModel.fetchUserAddresses()
            if fromCart == true {
                viewModel.getDraftOrderById()
            }
        }
    }
}

struct UserAddresses_Previews: PreviewProvider {
    static var previews: some View {
        UserAddresses(fromCart: false, didSelectAddress: {_ in})
    }
}
