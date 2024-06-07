//
//  ProductCell.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 27/05/2024.
//

import SwiftUI

struct ProductCell: View {
    let product: PopularProductItem
    init(product: PopularProductItem) {
        self.product = product
        setupPageControlAppearance()
    }
    var body: some View {
        NavigationLink(destination: ProductDetailView(productID: product.id?.description ?? " ")) {
        VStack{
                if let images = product.images, !images.isEmpty {
                    TabView {
                        ForEach(images, id: \.id) { image in
                            if let imageUrl = image.src, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 175, height: 200)
                                } placeholder: {
                                    ProgressView()
                                }
                            } else {
                                Color.gray.frame(width: 175, height: 200)
                            }
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .frame(width: 175, height: 200)
                } else {
                    Color.gray.frame(width: 175, height: 200)
                }
            VStack(alignment:.leading){
                HStack{
                    Text(product.vendor ?? "Unknown Vendor").foregroundColor(.gray).font(.system(size: 16, weight: .regular))
                    Spacer()
//                    Image("rate")
                    Text(product.product_type ?? "sho").font(.system(size: 12, weight: .regular))
                }
                HStack{
                    Text(product.title ?? "Adidas shoes").lineLimit(1).font(.system(size: 12, weight: .regular))
                }
                HStack{
                    Text("\(product.variants?[0].price ?? "100") USD").foregroundColor(.red).font(.system(size: 16, weight: .regular))
                    Spacer()
                    if let priceString = product.variants?.first?.price,
                       let price = Double(priceString) {
                        Text(String(format: "%.2f USD", price + 20))
                            .foregroundColor(.gray)
                            .strikethrough(color: .gray)
                            .font(.system(size: 16, weight: .regular))
                    } else {
                        Text("N/A USD")
                            .foregroundColor(.gray)
                            .strikethrough(color: .gray)
                            .font(.system(size: 16, weight: .regular))
                    }
                }
                }
            }
        }.frame(width: 175,height: 280)
    }
    private func setupPageControlAppearance() {
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
        }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: PopularProductItem(id: 1, title: "1", bodyHtml: "1", vendor: "1", product_type: nil, createdAt: nil, handle: nil, updatedAt: nil, publishedAt: nil, templateSuffix: nil, tags: nil, adminGraphqlApiId: nil, variants: nil, options: nil, images: nil, image: nil))
    }
}
