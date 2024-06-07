//
//  UserAdresses.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct UserAddresses: View {
    var addresses: [AddressResponse]
    
    var body: some View {
        VStack{
            ScrollView{
                ForEach(addresses,id: \.id) { address in
                    AddressCell(address: address)
                }
            }
            .navigationBarTitle("Addresses")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
        }
    }
}

struct UserAddresses_Previews: PreviewProvider {
    static var previews: some View {
        UserAddresses(addresses: [])
    }
}
