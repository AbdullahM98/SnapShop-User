//
//  ProductCell.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 25/05/2024.
//

import SwiftUI

struct ProductCell: View {
    var body: some View {
        VStack{
            ZStack{
                Image("productbg")
                Image("shirt")
            }
            VStack(alignment:.leading){
                HStack(){
                    Text("H&M")
                    Image("rate")
                    Text("4.9")
                    Text("(136)")
                        .foregroundColor(.gray)
                }
                Text("Oversize Fit Printed T-shirt")
                HStack{
                    Text("USD 225.0").foregroundColor(.red)
                    Text("300")
                        .foregroundColor(.gray)
                        .strikethrough(color: .gray)

                    
                }
            }
        }
    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell()
    }
}
