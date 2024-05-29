//
//  BrandCell.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct BrandCell: View {
    var body: some View {
        VStack{
            ZStack{
                Image("circle").frame(width: 55,height: 55)
                Image("brand").frame(width: 32,height: 32)
            }
            Text("brand")
                .font(.system(size: 14, weight: .semibold))
        }.frame(width: 55,height: 79)
    }
}

struct BrandCell_Previews: PreviewProvider {
    static var previews: some View {
        BrandCell()
    }
}
