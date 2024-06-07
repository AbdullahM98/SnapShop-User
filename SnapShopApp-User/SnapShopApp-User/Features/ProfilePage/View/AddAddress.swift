//
//  AddAddress.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct AddAddress: View {
    @State private var text: String = ""
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Text("Add New Address")
                    .font(.title2)
                Spacer()
            }.padding(.vertical,16)
                .padding(.top,32)
            VStack(alignment: .leading){
                Text("Address")
                TextField("name@example.com", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }.padding(.horizontal,16)
            HStack {
                VStack(alignment: .leading){
                    Text("Country")
                    TextField("Example", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                VStack(alignment: .leading){
                    Text("City")
                    TextField("Example", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Phone Number")
                TextField("+20 XXXX XXX XXX", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Zip Code")
                TextField("6789", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }.padding(.horizontal,16)
            HStack{
                ZStack {
                    HStack {
                        Button(action: {}) {
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
                .padding(.bottom,16)
        }
    }
}

struct AddAddress_Previews: PreviewProvider {
    static var previews: some View {
        AddAddress()
    }
}
