//
//  OrderCell.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import SwiftUI

struct OrderCell: View {
    @State var orderDetails: Order
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let orderNumber = orderDetails.name {
                HStack {
                    Text("Order No: ")
                        .foregroundColor(.gray)
                    Text(orderNumber)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            
            HStack {
                Text("No of items: ")
                    .foregroundColor(.gray)
                Text("\(orderDetails.line_items?.count ?? 0)")
                Spacer()
            }
            .padding(.horizontal, 16)
            
            if let address = orderDetails.shipping_address?.address1,
               let city = orderDetails.shipping_address?.city {
                HStack {
                    Text("Address: ")
                        .foregroundColor(.gray)
                    Text("\(address), \(city)")
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            
            if let moneyPaid = orderDetails.current_total_price {
                HStack {
                    Text("Money Paid: ")
                        .foregroundColor(.gray)
                    Text("\(moneyPaid) USD")
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
            
            if let date = orderDetails.created_at {
                HStack {
                    Text("Date: ")
                        .foregroundColor(.gray)
                    Text(date)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isDarkMode ? Color.blue : Color.black, lineWidth: 1)
                .shadow(radius: 5)
        )
        .padding()
    }
}

