//
//  CategoryProducts.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct CategoryProducts: View {
    var products: [PopularProductItem]
    private let
    adaptiveColumns = [
        GridItem(.adaptive (minimum: 170))
    ]
    
    var body: some View {
        VStack(alignment:.leading ){
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.screenWidth/2-35,maximum: UIScreen.screenWidth/2-5))]) {
                    ForEach(products, id: \.id) { product in
                        ProductCell(product: product)
                    }
                }
            }
        }.padding(.horizontal,16).padding(.top,8)
    }
}


struct CategoryProducts_Previews: PreviewProvider {
    static var previews: some View {
        CategoryProducts(products: [PopularProductItem]())
    }
}
