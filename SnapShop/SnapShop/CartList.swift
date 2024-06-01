//
//  CartList.swift
//  SnapShop
//
//  Created by husayn on 24/05/2024.
//

import SwiftUI

struct CartList: View {
    var body: some View {
        NavigationStack{
            List{
                CartCard()
                CartCard()
                CartCard()
                CartCard()
                CartCard()
                CartCard()
                CartCard()
                CartCard()
            }.navigationTitle("My Cart")
                .listStyle(PlainListStyle())
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("Sub-Total")
                            .foregroundColor(.gray)
                        Text("Taxex")
                            .foregroundColor(.gray)
                        Text("Discount")
                            .foregroundColor(.gray)
                    }.padding(2)
                    Spacer()
                    VStack(alignment: .leading){
                        Text("$850")
                            .foregroundColor(.gray)
                        Text("+$15")
                            .foregroundColor(.gray)
                        Text("-$32.00")
                            .foregroundColor(.red)
                    }.padding(2)
                    
                }.padding()
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray)
                HStack{
                    Text("Total")
                    Spacer()
                    Text("$1075")
                }.padding()
            }
            AppButton(text: "Checkout",width: 300,height: 40,bgColor: Color.black.opacity(0.9) , isFilled: true)
            Spacer()
        }
        
    }
}

struct CartList_Previews: PreviewProvider {
    static var previews: some View {
        CartList()
    }
}
