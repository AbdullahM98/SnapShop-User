//
//  BestSeller.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 27/05/2024.
//

import SwiftUI

struct BestSeller: View {
    @ObservedObject var viewModel : HomeViewModel
    private let
    adaptiveColumns = [
        GridItem(.adaptive (minimum: 170))
    ]
    
    var body: some View {
        VStack(alignment:.leading ){
            Text("Best Seller").font(.system(size: 20, weight: .semibold))
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: UIScreen.screenWidth/2-35,maximum: UIScreen.screenWidth/2-5))]) {
                    ForEach(viewModel.products, id: \.id) { product in
                        ProductCell(product: product)
                    }
                }
            }
        }.padding(.horizontal,16).padding(.top,8)
    }
}


struct BestSeller_Previews: PreviewProvider {
    static var previews: some View {
        BestSeller(viewModel: HomeViewModel())
    }
}
