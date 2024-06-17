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
                DeveloperInfo(personName: "Abdullah Essam", personImage: "abdullah")
                DeveloperInfo(personName: "Mostafa Sobaih", personImage: "sobaih")
                DeveloperInfo(personName: "Al-Hussein Abdulaziz", personImage: "husayn")
                DeveloperInfo(personName: "Hadir Elnajdy", personImage: "hadir")
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
