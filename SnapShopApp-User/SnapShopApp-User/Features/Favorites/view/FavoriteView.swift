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
        if $viewModel.viewState.wrappedValue == .userActive {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/).onAppear{
                let product = ProductEntity(userId: "87x2sShLCufCoBuI0aVvMaXWqrk2", id: "22", variant_Id: "2", title: "some", body_html: "desssssscripton", vendor: "nov", product_type: "clothe", inventory_quantity: "5", tags: "winter", price: "300", images: ["some"],isFav: true)
                viewModel.addProductToFavorites(product: product)
                viewModel.fetchFavProducts(userId: "87x2sShLCufCoBuI0aVvMaXWqrk2")
            }
        }else if $viewModel.viewState.wrappedValue == .loading {
            VStack {
                Spacer()
                CustomCircularProgress()
                Spacer()
            }

        }else{
            // show no fav image 
            VStack(alignment:.center){
                Image("empty_box").resizable().padding(.vertical,150)
            }
        }
    }
}

#Preview {
    FavoriteView(viewModel: FavoriteViewModel())
}
