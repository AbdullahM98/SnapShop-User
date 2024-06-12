//
//  CartList.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI

struct CartList: View {
    @ObservedObject var viewModel = CartViewModel()
    @State private var navigateToPayment = false // Flag to trigger navigation
    
    var body: some View {
        VStack{
            if $viewModel.viewState.wrappedValue == .userActive {
                
                Text("Cart").padding(.vertical,30).font(.title3)
                ScrollView{
                    ForEach(viewModel.lineItems ,id: \.id) { item in
                        CartCard(item: item,onDeleteClick: { product in
                            viewModel.getDraftOrderById(lineItem: product)
                        })
                    }
                }
                
                HStack(alignment: .center){
                    Text("Total: ")
                    Text(String(format: "%.2f",viewModel.total))
                        .bold()
                    
                    Text("EGP")
                    Spacer()
                    NavigationLink(destination: CheckOutPage(), isActive: $navigateToPayment) {
                        AppButton(text: "Checkout",width: 140,height: 40, isFilled: true, onClick: {
                            navigateToPayment = true
                        } )
                    }
                    
                }.padding()
            }else if $viewModel.viewState.wrappedValue == .loading{
                VStack {
                    Spacer()
                    CustomCircularProgress()
                    Spacer()
                }

            }else {
                VStack(alignment:.center){
                    Image("empty_box").resizable().padding(.vertical,150)
                }            }
        }.onAppear{
            //viewModel.getCardDraftOrder()
        }
    }
}


struct CartList_Previews: PreviewProvider {
    static var previews: some View {
        CartList()
    }
}
