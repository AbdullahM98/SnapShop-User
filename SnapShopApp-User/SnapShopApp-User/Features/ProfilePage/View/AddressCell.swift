//
//  AddressCell.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI
struct AddressCell: View {
    var address : AddressResponse
    @ObservedObject var viewModel:ProfileViewModel = ProfileViewModel.shared

    var body: some View {
        VStack(alignment:.leading,spacing: 16){
            HStack{
                Text("Address: ")
                    .foregroundColor(.gray)
                Text("\(address.address1 ?? "")")
                Spacer()
                Button {
                    if address.default == false {
                        print("inside if ")

                            viewModel.deleteAddress(addressId: address.id ?? 0)
                        print(address.default)

                    } else {
                        print("inside else show alert saying cant delete")
                        
                        print(address.default)

                    }
                } label: {
                    if address.default == false {
                        Image("trash")
                    }else{
                        Image("")
                    }
                }
            }.padding(.top,20)
                .padding(.horizontal,16)
            HStack{
                Text("City: ")
                    .foregroundColor(.gray)
                Text("\(address.city ?? "")")
            }.padding(.vertical,4)
                .padding(.horizontal,16)
            HStack{
                Text("Country: ")
                    .foregroundColor(.gray)
                Text("\(address.country ?? "")")
            }.padding(.vertical,4)
                .padding(.horizontal,16)
            HStack{
                Text("Zip Code: ")
                    .foregroundColor(.gray)
                Text("77750")
            }.padding(.vertical,4)
                .padding(.horizontal,16)
            HStack{
                Text("Phone Number: ")
                    .foregroundColor(.gray)
                Text("\(address.phone ?? "")")
            }.padding(.vertical,4)
                .padding(.horizontal,16)
                .padding(.bottom,20)
        }.border(Color.gray,width: 1)
            .padding(16)
            
    }
}

struct AddressCell_Previews: PreviewProvider {
    static var previews: some View {
        AddressCell(address: AddressResponse(id: 0, customer_id: 0, first_name: "", last_name: "", company: "", address1: "", address2: "", city: "", province: "", country: "", zip: "", phone: "", name: "", province_code: "", country_code: "", country_name: "", default: true))
    }
}
