//
//  AppButton.swift
//  SnapShop
//
//  Created by Abdullah Essam on 22/05/2024.
//

import SwiftUI


struct AppButton: View {
    private var text: String
    private var width: CGFloat
    private var height: CGFloat
    private var bgColor: Color
    private var isFilled: Bool
    
    init(text: String, width: CGFloat, height: CGFloat, bgColor: Color, isFilled: Bool = false) {
        self.text = text
        self.width = width
        self.height = height
        self.bgColor = bgColor
        self.isFilled = isFilled
    }
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {}) {
                    Text(text)
                       .font(.custom(FontTypes.bold.rawValue, size: CGFloat(FontSizes.subtitle.rawValue)))
                       .foregroundColor(isFilled ? Color.white : Color.black)
                }
               .frame(width: width, height: height)
               .background(isFilled ? bgColor : Color.clear)
               .clipShape(RoundedRectangle(cornerRadius: 6))
            }
           .overlay(
                RoundedRectangle(cornerRadius: 6)
                   .stroke(isFilled ? Color.clear : Color.black, lineWidth: 2)
            )
        }
    }
}
//
//    #Preview {
//        AppButton(text: "confirm",width: 100,height: 50,bgColor: Color.black , isFilled: true)
//    }

struct AppButton_Previews: PreviewProvider {
    static var previews: some View {
            AppButton(text: "confirm",width: 100,height: 50,bgColor: Color.black , isFilled: true)
    }
}

