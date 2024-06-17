//
//  AutoDismissAlert.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 14/06/2024.
//

import SwiftUI

struct AutoDismissAlert: View {
    var title: String
    var message: String
    var time: Double
    @State private var isVisible = true

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .frame(width: UIScreen.screenWidth - 100)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 40)
        .opacity(isVisible ? 1 : 0)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                withAnimation {
                    isVisible = false
                }
            }
        }
    }
}


struct AutoDismissAlert_Previews: PreviewProvider {
    static var previews: some View {
        AutoDismissAlert(title: "You Choose This Option :", message: "T-Shirt",time: 5)
    }
}
