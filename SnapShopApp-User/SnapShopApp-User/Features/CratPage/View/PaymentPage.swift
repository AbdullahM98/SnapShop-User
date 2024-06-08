//
//  PaymentPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI


struct PaymentPage: View {
    var onApplePayClick : () -> Void
    var onCashOnDeliveryClick : () -> Void

    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Image("payment")
                Spacer()
            }.padding(.bottom,32)
                .padding(.top,16)
            Text("Apple pay - convenient, secure and confidential way of payments")
                .multilineTextAlignment(.center)
            VStack(alignment: .leading) {
                Text("PaymentMethod")
                    .padding(.top,64)
                    .font(.title2)
                ButtonWithImage(text: "Check out With", imageName: "payment", textColor: .black, buttonColor: .clear, borderColor: .black, buttonWidth: 353,imageExist: true, onClick: onApplePayClick)
                
                ButtonWithImage(text: "Cash On Delivery ", imageName: "bsag", textColor: .white, buttonColor: .black, borderColor: .black, buttonWidth: 353,imageExist: false, onClick: onCashOnDeliveryClick)
            }.padding(.horizontal,8)
        }.padding(.horizontal,8)
    }
}



struct PaymentPage_Previews: PreviewProvider {
    static var previews: some View {
        PaymentPage(onApplePayClick: {}, onCashOnDeliveryClick: {})
    }
}
