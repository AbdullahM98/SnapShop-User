//
//  CustomColorDot.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 07/06/2024.
//


import SwiftUI

struct CustomColorDot: View {
    var color: Color
    var isSelected: Bool

    var body: some View {
        ZStack {
            color
                .frame(width: 24, height: 24)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.black : Color.clear, lineWidth: 2)
                )

            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.system(size: 12))
            }
        }
    }
}

struct ColorDotView_Previews: PreviewProvider {
    static var previews: some View {
        CustomColorDot(color: .red, isSelected: true)
    }
}
