//
//  CartList.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI

struct CartList: View {
    @StateObject var viewModel = CartViewModel()
    @State private var navigateToPayment = false // Flag to trigger navigation
    var body: some View {
        VStack{
            if $viewModel.viewState.wrappedValue == .userActive {
                if viewModel.isLoading {
                    VStack {
                        Spacer()
                        
                        LottieView(animationFileName: "ShoppingAnimation", loopMode: .loop)
                            .frame(width: 200, height: 200)
                        Spacer()
                    }
                }else if ((viewModel.lineItems) == nil) {
                    VStack(alignment:.center){
                        Image("empty-cart").resizable().padding(.vertical,150)
                    }
                }else{
                    ScrollView{
                        ForEach(viewModel.lineItems ?? [] ,id: \.id) { item in
                            CartCard(item: item,onDeleteClick: { product in
                                viewModel.deleteLineItemFromDraftOrder(lineItem: product)
                            })
                        }
                    }
                    
                    if (UserDefaultsManager.shared.hasDraft ?? false) {
                        HStack(alignment: .center){
                            Text("Total: \(String(format: "%.0f",(Double(viewModel.userOrder?.subtotal_price ?? "1.0" ) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                            Spacer()
                            NavigationLink(destination: CheckOutPage(), isActive: $navigateToPayment) {
                                AppButton(text: "Checkout",width: 140,height: 40, isFilled: true, onClick: {
                                    UserDefaultsManager.shared.selectedCouponCodeValue = ""
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
        }
        .navigationBarTitle("Cart")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .onAppear{
            viewModel.getDraftOrderById()
        }
    }
}


struct CartList_Previews: PreviewProvider {
    static var previews: some View {
        CartList()
    }
}
