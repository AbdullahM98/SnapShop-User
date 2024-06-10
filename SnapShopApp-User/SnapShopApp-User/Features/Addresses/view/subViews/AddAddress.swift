//
//  AddAddress.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct AddAddress: View {
    @State var addresses: [AddressProfileDetails]?
    @State var addressTextFieldData: String = ""
    @State var cityTextFieldData: String = ""
    @State var countryTextFieldData: String = ""
    @State var zipTextFieldData: String = ""
    @State var phoneAddressTextFieldData: String = ""
    var onSaveClick : (_ address:NewAddressRoot) -> Void
    var onCancelClick : () -> Void

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Text("Add New Address")
                    .font(.title2)
                Spacer()
            }.padding(.vertical,4)
            
            VStack(alignment: .leading){
                Text("Address")
                    .padding(.top,32)
                TextField("Street No.", text: $addressTextFieldData)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }.padding(.horizontal,16)
            HStack {
                VStack(alignment: .leading){
                    Text("Country")
                    TextField("Example", text: $countryTextFieldData)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                VStack(alignment: .leading){
                    Text("City")
                    TextField("Example", text: $cityTextFieldData)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
             
                    
                }
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Phone Number")
                TextField("+20 XXXX XXX XXX", text: $phoneAddressTextFieldData)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
                  
                
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Zip Code")
                TextField("6789", text: $zipTextFieldData)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                   
                
            }.padding(.horizontal,16)
            HStack{
                ZStack {
                    HStack {
                        Button(action: {
                            onCancelClick()
                        }) {
                                Text("Cancel")
                                .foregroundColor(.black)
                        }
                        .frame(width: 170, height: 44)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black  ,lineWidth: 2)
                    )
                }
                ZStack {
                    HStack {
                        Button(action: {
                            onSaveClick(NewAddressRoot(customer_address: NewAddressDetails(id: nil, customer_id: Int("7290794967219"), address1: addressTextFieldData, address2: nil, city: cityTextFieldData, zip: zipTextFieldData, phone: phoneAddressTextFieldData, name: nil, province_code: nil, country_code: "EG", country_name: countryTextFieldData, default: false)))
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                        }
                        .frame(width: 170, height: 44)
                        .background(Color.black.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }.padding(.horizontal)
                .padding(.vertical)
                .padding(.bottom,32)
        }
    }
}

struct AddAddress_Previews: PreviewProvider {
    static var previews: some View {
        AddAddress(onSaveClick: {address in }, onCancelClick: {})
    }
}
