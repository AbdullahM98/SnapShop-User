//
//  FavoriteView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 11/06/2024.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject var viewModel = FavoriteViewModel()
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).onAppear{
            let product = ProductEntity(userId: "87x2sShLCufCoBuI0aVvMaXWqrk2", id: "2", variant_Id: "2", title: "some", body_html: "bew bew", vendor: "nov", product_type: "clothe", inventory_quantity: "5", tags: "winter", price: "300", images: ["some"],isFav: true)
            viewModel.addProductToFavorites(product: product)
            viewModel.fetchFavProducts(userId: "87x2sShLCufCoBuI0aVvMaXWqrk2")
        }
    }
}

#Preview {
    FavoriteView(viewModel: FavoriteViewModel())
}
