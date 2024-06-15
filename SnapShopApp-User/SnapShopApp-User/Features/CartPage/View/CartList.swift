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
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        CustomCircularProgress()
                        Spacer()
                    }
                }else if ((viewModel.lineItems) == nil) {
                    VStack(alignment:.center){
                        Image("empty_box").resizable().padding(.vertical,150)
                    }
                }else{
                    
                    Text("Cart").padding(.vertical,30).font(.title3)
                    ScrollView{
                        ForEach(viewModel.lineItems ?? [] ,id: \.id) { item in
                            CartCard(item: item,onDeleteClick: { product in
                                viewModel.deleteLineItemFromDraftOrder(lineItem: product)
                            })
                        }
                    }
                    
                    if (UserDefaultsManager.shared.getUserHasDraftOrders(key: "HasDraft") ?? false) {
                        HStack(alignment: .center){
                            Text("Total: \(viewModel.userOrder?.subtotal_price ?? "0.0")")
                            Text("EGP")
                            Spacer()
                            NavigationLink(destination: CheckOutPage(cartViewModel: viewModel, address: viewModel.shippingAddress ?? DraftOrderAddress(first_name: "", address1: "", phone: "", city: "", zip: "", province: "", country: "", last_name: "", address2: "", company: "", latitude: 0.0, longitude: 0.0, name: "", country_code: "", province_code: "")), isActive: $navigateToPayment) {
                                AppButton(text: "Checkout",width: 140,height: 40, isFilled: true, onClick: {
                                    navigateToPayment = true
                                } )
                            }
                            
                        }.padding()
                    }
                }
            }else {
                VStack(alignment:.center){
                    Image("empty_box").resizable().padding(.vertical,150)
                }
            }
        }.onAppear{
            viewModel.getDraftOrderById()
        }
    }
}


struct CartList_Previews: PreviewProvider {
    static var previews: some View {
        CartList()
    }
}
