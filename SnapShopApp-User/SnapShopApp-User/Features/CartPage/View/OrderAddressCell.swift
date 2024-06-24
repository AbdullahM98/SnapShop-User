//
//  OrderAddressCell.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 15/06/2024.
//

import SwiftUI

struct OrderAddressCell: View {
    var address : AddressProfileDetails
    var body: some View {
        VStack(alignment:.leading,spacing: 20){
            if let customerAddress = address.address1 {
                if !customerAddress.isEmpty{
                    HStack{
                        Text("Street: ")
                            .foregroundColor(.gray)
                        Text("\(address.address1 ?? "")")
                        Spacer()
                        
                    }.padding(.horizontal,16)
                }
            }
            if let city = address.city{
                if !city.isEmpty{
                    HStack{
                        Text("City: ")
                            .foregroundColor(.gray)
                        Text("\(address.city ?? "")")
                    }.padding(.horizontal,16)
                }
                
            }
            if let country = address.country {
                if !country.isEmpty{
                    HStack{
                        Text("Country: ")
                            .foregroundColor(.gray)
                        Text("\(address.country ?? "")")
                    }.padding(.horizontal,16)
                }
                
            }
            if let phone = address.phone {
                if !phone.isEmpty{
                    HStack{
                        Text("Phone Number: ")
                            .foregroundColor(.gray)
                        Text("\(address.phone ?? "")")
                    }.padding(.horizontal,16)
                    
                }
                
            }
        }
        .padding(.vertical,20).overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.black, lineWidth: 1).shadow(radius: 5)
        }.padding()
        
    }
}

struct OrderAddressCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderAddressCell(address: AddressProfileDetails(id: 0, customer_id: 0, first_name: "husayn", last_name: "abdulaziz", company: "iti", address1: "elamar sory", address2: "elzohor", city: "portsaid", province: "", country: "Egypt", zip: "45475", phone: "+201285340330", name: "husayn", province_code: "4545", country_code: "+20", country_name: "Egypt", default: true))
    }
}
