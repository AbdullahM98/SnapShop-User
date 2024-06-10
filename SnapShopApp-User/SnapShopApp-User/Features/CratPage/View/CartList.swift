//
//  CartList.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI

struct CartList: View {
    @ObservedObject var viewModel = CartViewModel.shared
    @State private var navigateToPayment = false // Flag to trigger navigation
    var body: some View {
        VStack{
            Text("Cart")
            ScrollView{
                ForEach(viewModel.lineItems ,id: \.id) { item in
                    CartCard(item: item)
                }
            }
            
            HStack(alignment: .center){
                Text("Total: ")
                Text(String(format: "%.2f",viewModel.total))                    .bold()
                
                Text("EGP")
                Spacer()
                NavigationLink(destination: CheckOutPage(), isActive: $navigateToPayment) {
                    AppButton(text: "Checkout",width: 140,height: 40, isFilled: true, onClick: {
                        navigateToPayment = true
                    } )
                }
                
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

