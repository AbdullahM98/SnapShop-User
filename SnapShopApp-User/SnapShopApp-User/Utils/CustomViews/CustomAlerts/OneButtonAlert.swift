//
//  OneButtonAlert.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 14/06/2024.
//

import SwiftUI

struct OneButtonAlert: View {
    var title: String
    var message: String
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

            Button(action: onAction) {
                Text(buttonText)
                    .frame(minWidth: UIScreen.screenWidth - 150)
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


struct OneButtonAlert_Previews: PreviewProvider {
    static var previews: some View {
        OneButtonAlert(title: "Alert", message: "You Have to sign in to complete using the application", buttonText: "Sign In", onAction: {})
    }
}
