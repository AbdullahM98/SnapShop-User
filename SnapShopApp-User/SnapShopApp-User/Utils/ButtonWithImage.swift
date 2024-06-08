//
//  ButtonWithImage.swift
//  SwiftShop
//
//  Created by husayn on 02/06/2024.
//

import SwiftUI

struct ButtonWithImage: View {
    var text: String
    var imageName: String
    var textColor: Color
    var buttonColor: Color
    var borderColor: Color
    var buttonWidth: CGFloat
    var imageExist: Bool = false
    var onClick : () -> Void

    var body: some View {
        ZStack {
            HStack {
                Button(action: onClick) {
                    Text(text)
                        .foregroundColor(textColor)
                    if imageExist{
                        
                        Image(imageName)
                            .resizable()
                            .frame(width: 55,height: 25)
                    }
                }
                .frame(width: buttonWidth, height: 44)
                .background(buttonColor.opacity(0.8))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(borderColor  ,lineWidth: 2)
            )
        }.padding(.vertical,16)
        
    }
}

struct ButtonWithImage_Previews: PreviewProvider {
    static var previews: some View {
        ButtonWithImage(text: "Check out With ", imageName: "payment", textColor: .black, buttonColor: .white, borderColor: .orange, buttonWidth: 353,imageExist: true, onClick: {})
    }
}
