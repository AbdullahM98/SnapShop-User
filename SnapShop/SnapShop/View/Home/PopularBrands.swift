//
//  BrandsView.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct PopularBrands: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Popular Brands")               
                .font(.system(size: 20, weight: .semibold))
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
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                    BrandCell()
                }
            }.scrollIndicators(.hidden)
        }.padding(.horizontal,16).padding(.top,16)
    }
}

struct BrandsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularBrands()
    }
}
