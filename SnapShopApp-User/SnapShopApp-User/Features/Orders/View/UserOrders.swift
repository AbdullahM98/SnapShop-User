//
//  UserOrders.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import Foundation
import SwiftUI

struct UserOrders: View {
    @State var orderList: [Order]

    var body: some View {
        VStack {
            if orderList.isEmpty {
                Spacer()
                Image("no_order")
                    .resizable()
                    .scaledToFit()
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    ForEach(orderList, id: \.id) { order in
                        OrderCell(orderDetails: order)
                    }
                }
            }
        }
        .navigationBarTitle("Orders")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

struct UserOrders_Previews: PreviewProvider {
    static var previews: some View {
        UserOrders(orderList: [])
    }
}
