//
//  AboutUs.swift
//  SnapShopApp-User
//
//  Created by husayn on 14/06/2024.
//

import SwiftUI

struct AboutUs: View {
    var body: some View {
        VStack{
            ScrollView{
                VStack(spacing: 20){
                    Text("We are a team of passionate developers dedicated to creating exceptional mobile apps.").multilineTextAlignment(.center)
                        .padding(.all,24)
                    DeveloperInfo(personName: "Abdullah Essam", personImage: "abdullah")
                    DeveloperInfo1(personName: "Mostafa Sobaih", personImage: "sobaih")
                    DeveloperInfo(personName: "Al-Hussein Abdulaziz", personImage: "husayn")
                    DeveloperInfo1(personName: "Hadir Elnajdy", personImage: "hadir")
                    Text("Mobile Application Development")
                        .padding(.bottom,16)
                }
            }.scrollIndicators(.hidden)
        }.navigationBarTitle("About Us")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
    }
}

struct AboutUs_Previews: PreviewProvider {
    static var previews: some View {
        AboutUs()
    }
}
