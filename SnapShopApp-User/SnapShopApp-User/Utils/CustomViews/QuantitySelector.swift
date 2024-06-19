//
//  QuantitySelector.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 19/06/2024.
//

import Foundation
import SwiftUI

struct QuantitySelectorView: View {
    @State private var quantity: Int = 1
    let maxValue: Int // Maximum value allowed
    
    init(quantity : Int) {
        self.quantity = quantity
        maxValue = quantity - 2
    }
    
    var body: some View {
        HStack {
            Button(action: {
                if quantity > 1 {
                    quantity -= 1
                }
            }) {
                Image(systemName: "minus.circle")
                    .font(.title)
                    .foregroundColor(quantity > 1 ? .black : .gray) // Disable if quantity is 1
            }
            .padding(.trailing, 8)
            
            Text("\(quantity)")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 40)
                .multilineTextAlignment(.center)
            
            Button(action: {
                if quantity < maxValue {
                    quantity += 1
                }
            }) {
                Image(systemName: "plus.circle")
                    .font(.title)
                    .foregroundColor(quantity < maxValue ? .black : .gray) // Disable if quantity reaches maxValue
            }
            .padding(.leading, 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 1.5).opacity(0.3).frame(width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.06)
        )
        
    }
}

struct QuantitySelectorView_Previews: PreviewProvider {
    static var previews: some View {
        QuantitySelectorView(quantity: 3)
    }
}
