//
//  BrandCell.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct BrandCell: View {
    @ObservedObject var viewModel : HomeViewModel
    var brand: SmartCollectionsItem

    var body: some View {
        NavigationLink(destination: BrandProducts(viewModel: viewModel,brand: brand)) {
            VStack{
                Spacer()
                ZStack{
                    if let imageUrl = brand.image?.src, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                // Image with border
                                image
                                    .resizable()
                                    .frame(width: 70, height: 70).padding(.all,5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.gray, lineWidth: 2)
                                    )
                            case .failure(_):
                                // Placeholder for failure
                                Image(systemName: "xmark.circle")
                                    .frame(width: 60, height: 60)
                            case .empty:
                                // Placeholder for empty
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            @unknown default:
                                // Placeholder for unknown
                                ProgressView()
                                    .frame(width: 60, height: 60)
                            }
                        }
                    } else {
                        // Placeholder for no image URL
                        Image(systemName: "questionmark.circle")
                            .frame(width: 60, height: 60)
                    }
                }
                Spacer()
                Text(brand.title ?? "Unknown Brand")
                    .font(.system(size: 14,weight: .semibold))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .frame(width: 90)
            }.frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/,height: 120)
        }
    }
}

struct BrandCell_Previews: PreviewProvider {
    static var previews: some View {
        BrandCell(viewModel: HomeViewModel(),brand: SmartCollectionsItem(image: BrandImage(src: nil, alt: nil, width: nil, createdAt: nil, height: nil), bodyHtml: nil, handle: nil, rules: nil, title: "Sample Brand", publishedScope: nil, templateSuffix: nil, updatedAt: nil, disjunctive: nil, adminGraphqlApiId: nil, id: 1, publishedAt: nil, sortOrder: nil))
    }
}
