//
//  PersonInfo.swift
//  SnapShopApp-User
//
//  Created by husayn on 14/06/2024.
//

import SwiftUI

struct PersonInfo: View {
    var personName:String
    var personImage:String
    var body: some View {
        VStack(alignment: .center, spacing: 20){
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

