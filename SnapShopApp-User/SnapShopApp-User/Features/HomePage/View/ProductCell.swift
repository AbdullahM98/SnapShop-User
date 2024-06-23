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
                    Text(extractedTitle(product.title)).lineLimit(1).font(.system(size: 12, weight: .regular)).foregroundColor(.black)
                }
                HStack{
                    Text("\(String(format: "%.0f",(Double(product.variants?[0].price ?? "1.0" ) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")").foregroundColor(.red).font(.system(size: 14, weight: .regular))
                    Spacer()
                    if let priceString = product.variants?.first?.price,
                       let price = Double(priceString) {
                        Text("\(String(format: "%.0f",((Double(product.variants?[0].price ?? "1.0" ) ?? 1 )  * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1)) * 1.1)) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                            .foregroundColor(.gray)
                            .strikethrough(color: .gray)
                            .font(.system(size: 14, weight: .regular))
                    } else {
                        Text("N/A")
                            .foregroundColor(.gray)
                            .strikethrough(color: .gray)
                            .font(.system(size: 14, weight: .regular))
                    }
                }
                }
            }
        }.padding()
        .frame(width: 170,height: 280)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
    
    private func extractedTitle(_ title: String?) -> String {
        guard let title = title else { return "Unknown Title" }
        let components = title.split(separator: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        if components.count > 1 {
            return components[1]
        } else {
            return title
        }
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
