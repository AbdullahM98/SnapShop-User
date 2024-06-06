//
//  AddressCell.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI
struct AddressCell: View {
    var body: some View {
        VStack(alignment:.leading,spacing: 16){
            HStack{
                Text("Address: ")
                    .foregroundColor(.gray)
                Text("12 ST, Suez Canal University")
                Spacer()
                Image("bag")
            }.padding(.top,20)
                .padding(.horizontal,16)
            HStack{
                Text("City: ")
                    .foregroundColor(.gray)
                Text("Ismailia")
            }.padding(.vertical,4)
                .padding(.horizontal,16)
            HStack{
                Text("Country: ")
                    .foregroundColor(.gray)
                Text("Egypt")
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
                Text("+201285340330")
            }.padding(.vertical,4)
                .padding(.horizontal,16)
                .padding(.bottom,20)
        }.border(Color.gray,width: 1)
            .padding(16)
            
    }
}

struct AddressCell_Previews: PreviewProvider {
    static var previews: some View {
        AddressCell()
    }
}

