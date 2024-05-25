//
//  BrandsGrid.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 25/05/2024.
//

import SwiftUI

struct BrandsGrid: View {
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 70)) ,// Minimum item width of 50

    ]
    var body: some View {
        VStack(alignment: .leading){
            Text("Brands").bold()
            
            ScrollView(.horizontal){
                HStack{
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                }
            }.scrollIndicators(.hidden)
        }.padding(.all,8)
        
    }
}

struct BrandsGrid_Previews: PreviewProvider {
    static var previews: some View {
        BrandsGrid()
    }
}

