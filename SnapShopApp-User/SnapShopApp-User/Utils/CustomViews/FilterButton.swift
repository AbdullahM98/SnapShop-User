//
//  FilterButton.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct FilterButton: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var buttonName: String
    var nameWidth: Double
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(buttonName)
                    .font(.system(size: 12, weight: .semibold))
            }
            .padding()
            .background(isDarkMode ? Color.black : Color.white)
            .foregroundColor(isSelected ? Color.red : isDarkMode ? Color.white : Color.black)
            .cornerRadius(8)
            .frame(width: nameWidth, height: 30)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
            )
        }
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            FilterButton(buttonName: "Filter", nameWidth: 85, isSelected: true, action: {})
            FilterButton(buttonName: "Filter", nameWidth: 85, isSelected: false, action: {})
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

