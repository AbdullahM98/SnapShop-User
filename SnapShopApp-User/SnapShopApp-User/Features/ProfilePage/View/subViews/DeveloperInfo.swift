//
//  DeveloperInfo.swift
//  SnapShopApp-User
//
//  Created by husayn on 14/06/2024.
//

import SwiftUI

struct DeveloperInfo: View {
    var personName:String
    var personImage:String
    var body: some View {
        HStack(alignment: .center, spacing: 20){
            Image(personImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100,height: 100)
                .clipShape(Circle())
            Text(personName)
                .bold()
            
        }
    }
}
struct DeveloperInfo1: View {
    var personName:String
    var personImage:String
    var body: some View {
        HStack(alignment: .center, spacing: 20){
            
            Text(personName)
                .bold()
            Image(personImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100,height: 100)
                .clipShape(Circle())
        }
    }
}

