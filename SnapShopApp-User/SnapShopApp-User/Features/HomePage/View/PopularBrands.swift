//
//  BrandsView.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct PopularBrands: View {
    @StateObject var viewModel : HomeViewModel
    var body: some View {
        VStack(alignment: .leading){
            Text("Popular Brands")
                .font(.system(size: 20, weight: .semibold))
            ScrollView(.horizontal){
                HStack(spacing: 10){
                    ForEach(viewModel.smartCollections, id: \.id) { brand in
                        BrandCell(viewModel:viewModel,brand: brand)
                    }.padding(.all,4)
                }
            }.scrollIndicators(.hidden)
        }.padding(.horizontal,16)
            .padding(.top,8)
            .onAppear {
            viewModel.fetchBrands()
        }
    }
}

struct BrandsView_Previews: PreviewProvider {
    static var previews: some View {
        PopularBrands(viewModel: HomeViewModel())
    }
}
