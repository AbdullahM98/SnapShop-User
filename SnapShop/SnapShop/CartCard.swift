//
//  CartCard.swift
//  SnapShop
//
//  Created by husayn on 24/05/2024.
//

import SwiftUI

struct CartCard: View {
    @State var qty: Int = 1
    var body: some View {
        VStack{
            HStack{
                Image("product")
                    .aspectRatio(contentMode: .fit)
                VStack(alignment: .leading){
                    Text("Oversize Fit Printed T-shirt")
                        .lineLimit(1)
                    Text("Nike").foregroundColor(Color.gray)
                    HStack{
                        Text("USD 225")
                            .bold()
                        Spacer()
                        Button{
                           //minus quantity
                            self.qty -= 1
                        } label: {
                            Image(systemName: "minus")
                        }.foregroundColor(qty == 1 ? .gray : .black)
                        .disabled(self.qty == 1)
                        Text("\(self.qty)")
                            .padding(.horizontal,3)
                        Button{
                            //plus quantity
                            self.qty += 1
                        } label: {
                            Image(systemName: "plus")
                        }.foregroundColor(Color.black)
                    }.padding(.trailing)
                }.padding(.vertical)
            }
        }
    }
}

struct CartCard_Previews: PreviewProvider {
    static var previews: some View {
        CartCard()
    }
}
