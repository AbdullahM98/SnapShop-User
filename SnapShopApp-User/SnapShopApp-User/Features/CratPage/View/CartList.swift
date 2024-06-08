//
//  CartList.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI

struct CartList: View {
    @ObservedObject var viewModel = CartViewModel.shared
    var body: some View {
        VStack{
            Text("Cart")
            ScrollView{
                ForEach(viewModel.userOrders ?? [] ,id: \.id) { order in
                    CartCard(order: order)
                }
            }
            
            HStack(alignment: .center){
                Text("Total: ")
                Text(String(format: "%.2f",viewModel.total))                    .bold()
                
                Text("EGP")
                Spacer()
                AppButton(text: "Checkout",width: 140,height: 40, isFilled: true, onClick: {} )
                
            }.padding()
        }.onAppear{
            viewModel.getCardDraftOrder()
        }
    }
}


struct CartList_Previews: PreviewProvider {
    static var previews: some View {
        CartList()
    }
}

