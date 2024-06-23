//
//  CustomBackButton.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isDarkMode") private var isDarkMode = false


    var body: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 15, height: 15)
                .foregroundColor(isDarkMode ? Color.white : Color.black)
        }
    }
}

struct CustomBackButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomBackButton()
    }
}
