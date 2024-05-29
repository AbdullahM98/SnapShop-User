//
//  ProductCell.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 27/05/2024.
//

import SwiftUI

struct ProductCell: View {
    var body: some View {
        VStack{
            ZStack{
                Image("productbg").resizable().frame(width: 180,height: 200)
                Image("shirt")
            }
            VStack(alignment:.leading){
                HStack{
                    Text("H&M ").foregroundColor(.gray).font(.system(size: 16, weight: .regular))
                    Image("rate")
                    Text("4.9").font(.system(size: 16, weight: .regular))
                    Text("(136)").foregroundColor(.gray).font(.system(size: 16, weight: .regular))
                }
                HStack{
                    Text("Oversize Fit Printed T-shirt").lineLimit(1)
                }
                HStack{
                    Text("USD 225.00").foregroundColor(.red).font(.system(size: 16, weight: .regular))
                    Text("$300.00")
                        .foregroundColor(.gray)
                        .strikethrough(color: .gray)
                        .font(.system(size: 16, weight: .regular))
                }
            }
        }.frame(width: 180,height: 280)
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell()
    }
}
