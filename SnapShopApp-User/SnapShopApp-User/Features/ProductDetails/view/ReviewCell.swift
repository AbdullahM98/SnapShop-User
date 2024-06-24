//
//  ReviewCell.swift
//  SnapShopApp-User
//
//  Created by husayn on 23/06/2024.
//

import SwiftUI

import SwiftUI

struct ReviewCell: View {
    let reviewerName: String
    let reviewText: String
    let ratingText: String
    @AppStorage("isDarkMode") private var isDarkMode = false

    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack{
                
                Text(reviewerName)
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
                
                Image(systemName: "star.fill")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundColor(.yellow)
                
                Text("(\(ratingText))").font(.subheadline).foregroundStyle(isDarkMode ? Color.white : Color.black)
            }
            Text(reviewText)
                .font(.body)
                .foregroundColor(.black)
                .lineLimit(nil) // Adjust as needed for multiline reviews
        }
        .padding(12)
        .background(Color.gray.opacity(0.1)) // Optional background color
        .cornerRadius(8)
        .padding([.top, .horizontal])
    }
}


