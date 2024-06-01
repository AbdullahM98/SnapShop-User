//
//  BrandCell.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct BrandCell: View {
    var brand: SmartCollectionsItem

    var body: some View {
        VStack{
            ZStack{
                Image("circle").frame(width: 55,height: 55)
                if let imageUrl = brand.image?.src, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .frame(width: 32, height: 32)
                                
                        } else if phase.error != nil {
                            Image(systemName: "xmark.circle")
                                .frame(width: 32, height: 32)
                        } else {
                            ProgressView()
                                .frame(width: 32, height: 32)
                        }
                    }
                } else {
                    Image(systemName: "questionmark.circle")
                        .frame(width: 32, height: 32)
                }
            }
            Text(brand.title ?? "Unknown Brand")
                .font(.system(size: 10,weight: .semibold))
                .lineLimit(1)
                .frame(width: 55)
        }
    }
}

struct BrandCell_Previews: PreviewProvider {
    static var previews: some View {
        BrandCell(brand: SmartCollectionsItem(image: BrandImage(src: nil, alt: nil, width: nil, createdAt: nil, height: nil), bodyHtml: nil, handle: nil, rules: nil, title: "Sample Brand", publishedScope: nil, templateSuffix: nil, updatedAt: nil, disjunctive: nil, adminGraphqlApiId: nil, id: 1, publishedAt: nil, sortOrder: nil))
    }
}
