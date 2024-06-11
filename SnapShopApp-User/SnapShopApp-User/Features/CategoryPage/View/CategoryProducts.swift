//
//  CategoryProducts.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct CategoryProducts: View {
    var products: [PopularProductItem]
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 170))
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            if products.isEmpty {
                Spacer()
                Image("no-products")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: adaptiveColumns) {
                        ForEach(products, id: \.id) { product in
                            ProductCell(product: product)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}
