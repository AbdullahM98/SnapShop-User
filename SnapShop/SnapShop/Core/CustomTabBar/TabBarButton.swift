//
//  TabBarButton.swift
//  SnapShop
//
//  Created by husayn on 24/05/2024.
//

import SwiftUI

struct TabBarButton: View {
    var buttonText: String
    var imageName: String
    var isActive: Bool
    var body: some View {
        GeometryReader{ geo in
            if isActive {
                Rectangle()
                    .foregroundColor(Color.black)
                    .frame(width: geo.size.width/2,height: 3)
                    .padding(.leading,geo.size.width/4)
            }
            VStack (alignment: .center, spacing: 4){
                Image("\(isActive ? imageName + ".fill" : imageName)")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24,height: 24)
                Text("\(buttonText)")
            }.frame(width: geo.size.width,height: geo.size.height)
        }
    }
}

struct TabBarButton_Previews: PreviewProvider {
    static var previews: some View {
        TabBarButton(buttonText: "Home", imageName: "home", isActive: true)
    }
}
