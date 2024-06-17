//
//  AboutUs.swift
//  SnapShopApp-User
//
//  Created by husayn on 14/06/2024.
//

import SwiftUI

struct AboutUs: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 20){
                HStack{
                    Spacer()
                    Text("About Us")
                        .bold()
                    Spacer()
                }
                Text("We are a team of passionate developers dedicated to creating exceptional mobile apps.").multilineTextAlignment(.center)
                    .padding(.all,24)
                PersonInfo(personName: "Abdullah Essam", personImage: "abdullah")
                PersonInfo(personName: "Mostafa Sobaih", personImage: "sobaih")
                PersonInfo(personName: "Al-Hussein Abdulaziz", personImage: "husayn")
                PersonInfo(personName: "Hadir Elnajdy", personImage: "hadir")
                Text("Contact Us")
                Text("Email: snapshop@iti.com")
                    .foregroundColor(.gray)
                Text("Our Service")
                Text("Mobile Application Development")
                    .padding(.bottom,16)
            }
        }
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}
