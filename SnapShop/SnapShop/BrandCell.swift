//
//  BrandCell.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 25/05/2024.
//

import SwiftUI

struct BrandCell: View {
    var body: some View {
        VStack{
            ZStack{
                Image("circle")
                Image("brand")
            }
            Text("brand")
        }
    }
}

struct BrandCell_Previews: PreviewProvider {
    static var previews: some View {
        BrandCell()
    }
}
