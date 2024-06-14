//
//  ImageButtonAlert.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 14/06/2024.
//

import SwiftUI

struct ImageButtonAlert: View {
    var title: String
    var message: String
    var image: Image
    var buttonText: String
    var onAction: () -> Void

    var body: some View {
        VStack(spacing: 16) {
           

            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)

            image
                .resizable()
                .frame(width: UIScreen.screenWidth - 150,height: 150)
                .aspectRatio(contentMode: .fit)
                .cornerRadius(10)
            
            Button(action: onAction) {
                Text(buttonText)
                    .frame(width: UIScreen.screenWidth - 150)
                    .padding()
                    .background(Color.offWhite2)
                    .foregroundColor(.green)
                    .cornerRadius(8)
            }
        }
        .frame(width: UIScreen.screenWidth - 100)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 40)
    }
}

struct ImageButtonAlert_Previews: PreviewProvider {
    static var previews: some View {
        ImageButtonAlert(title: "Congratulations", message: "Your order is under preparation", image: Image("congratulations"), buttonText: "Home", onAction: {})
    }
}
