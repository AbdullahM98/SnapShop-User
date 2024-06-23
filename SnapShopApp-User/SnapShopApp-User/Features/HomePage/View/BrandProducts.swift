//
//  BrandProducts.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct BrandProducts: View {
    @StateObject var viewModel : HomeViewModel
    var brand: SmartCollectionsItem
    var products: [PopularProductItem] {
        viewModel.singleCategoryProducts
    }
    var body: some View {
        VStack{
            if viewModel.isLoadingBrandProducts {
                Spacer()
                ProgressView()
                Spacer()
                    .navigationBarBackButtonHidden(true)
            }else{
                CategoryProducts(products: viewModel.singleCategoryProducts)
                    .navigationBarTitle("\(String(describing: brand.title ?? "")) Products")
                    .navigationBarBackButtonHidden()
            }
        }
        .navigationBarItems(leading: CustomBackButton())
        .onAppear(){
            viewModel.isLoadingBrandProducts = true
            viewModel.fetchProductsInCollectionSingle(collectionID: "\(String(describing: brand.id ?? 0))")
            
        }
    }
}

struct BrandProducts_Previews: PreviewProvider {
    static var previews: some View {
        BrandProducts(viewModel: HomeViewModel(),brand: SmartCollectionsItem(image: BrandImage(src: nil, alt: nil, width: nil, createdAt: nil, height: nil), bodyHtml: nil, handle: nil, rules: nil, title: "Sample Brand", publishedScope: nil, templateSuffix: nil, updatedAt: nil, disjunctive: nil, adminGraphqlApiId: nil, id: 1, publishedAt: nil, sortOrder: nil))
    }
}


