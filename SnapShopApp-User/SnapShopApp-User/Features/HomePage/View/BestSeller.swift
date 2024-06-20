//
//  BestSeller.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 27/05/2024.
//

import SwiftUI

struct BestSeller: View {
    @StateObject var viewModel: HomeViewModel
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Best Seller")
                .font(.system(size: 20, weight: .semibold))
            ScrollView {
                if viewModel.products.isEmpty {
                    Image("no-products")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: adaptiveColumns) {
                        ForEach(viewModel.products, id: \.id) { product in
                            ProductCell(product: product)
                        }
                    }.padding(.vertical,8)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        
    }
}

struct BestSeller_Previews: PreviewProvider {
    static var previews: some View {
        BestSeller(viewModel: HomeViewModel())
    }
}
