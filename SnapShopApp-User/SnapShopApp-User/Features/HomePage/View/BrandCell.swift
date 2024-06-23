//
//  BrandCell.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct BrandCell: View {
    @StateObject var viewModel : HomeViewModel
    var brand: SmartCollectionsItem
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationLink(destination: BrandProducts(viewModel: viewModel,brand: brand)) {
            HStack(spacing: 8){
                    if let imageUrl = brand.image?.src, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                // Image with border
                                image
                                    .resizable()
                                    .frame(width: 27, height: 27).padding(.all,5)
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 10)
//                                            .stroke(Color.gray, lineWidth: 2)
//                                    )
                            case .failure(_):
                                // Placeholder for failure
                                Image(systemName: "xmark.circle")
                                    .frame(width: 27, height: 27)
                            case .empty:
                                // Placeholder for empty
                                ProgressView()
                                    .frame(width: 27, height: 27)
                            @unknown default:
                                // Placeholder for unknown
                                ProgressView()
                                    .frame(width: 27, height: 27)
                            }
                        }.background(isDarkMode ? Color.black : Color.white)
//                            .cornerRadius(10)
//                            .shadow(radius: 5)
                    } else {
                        // Placeholder for no image URL
                        Image(systemName: "questionmark.circle")
                            .frame(width: 30, height: 30)
                    }
                
                Text(brand.title ?? "Unknown Brand")
                    .font(.system(size: 14,weight: .semibold))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .frame(width: 90)
            }.frame(width: 140,height: 50)
                .background(isDarkMode ? Color.black : Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                
        }
    }
}

struct BrandCell_Previews: PreviewProvider {
    static var previews: some View {
        BrandCell(viewModel: HomeViewModel(),brand: SmartCollectionsItem(image: BrandImage(src: nil, alt: nil, width: nil, createdAt: nil, height: nil), bodyHtml: nil, handle: nil, rules: nil, title: "Sample Brand", publishedScope: nil, templateSuffix: nil, updatedAt: nil, disjunctive: nil, adminGraphqlApiId: nil, id: 1, publishedAt: nil, sortOrder: nil))
    }
}
