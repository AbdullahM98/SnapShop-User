//
//  BrandsView.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct PopularBrands: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading){
            Text("Popular Brands")
                .font(.system(size: 20, weight: .semibold))
            ScrollView(.horizontal){
                HStack{
                    ForEach(viewModel.smartCollections, id: \.id) { brand in
                        BrandCell(brand: brand)
                    }
                }
            }.scrollIndicators(.hidden)
        }.padding(.horizontal,16)
            .padding(.top,16)
            .onAppear {
            viewModel.fetchBrands()
                viewModel.fetchCoupons()
        }
    }
}

struct BrandsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularBrands()
    }
}
