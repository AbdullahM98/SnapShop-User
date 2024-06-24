//
//  CustomAppBar.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct CustomAppBar: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        HStack {
            Image(uiImage: UIImage(named: "snapshopLogo") ?? UIImage())
                .resizable()
                .frame(width: 32, height: 38)
            Text("Snap Shop")
                .font(.system(size: 20, weight: .bold))
                .padding(.leading, 8)
            Spacer()
        }
        .padding(.horizontal)
        .foregroundColor(isDarkMode ? Color.white : Color.black)
        Divider().background(isDarkMode ? Color.white : Color.black)
        
    }
}
struct CustomAppBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomAppBar()
    }
}
