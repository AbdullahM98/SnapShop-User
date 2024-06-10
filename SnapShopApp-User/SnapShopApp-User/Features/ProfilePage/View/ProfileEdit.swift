//
//  ProfileEdit.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct ProfileEdit: View {
    var onSaveClick : () -> Void
    var onCancelClick : () -> Void
    @ObservedObject var userData:ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Text("Edit Profile")
                    .font(.title2)
                Spacer()
            }
                .padding(.vertical,32)
            
            HStack {
                VStack(alignment: .leading){
                    Text("First Name")
                    TextField(userData.user?.first_name ?? "Example", text: $userData.firstNameTextFieldData)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                VStack(alignment: .leading){
                    Text("Second Name")
                    TextField(userData.user?.last_name ?? "Example", text: $userData.secondNameTextFieldData)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Email")
                TextField(userData.user?.email ?? "email@example.com", text: $userData.emailTextFieldData)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Phone Number")
                TextField(userData.user?.phone ?? "+20 XXXX XXX XXX", text: $userData.phoneTextFieldData)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }.padding(.horizontal,16)
            HStack{
                ZStack {
                    HStack {
                        Button(action: {
                            onCancelClick()
                        }) {
                                Text("Cancel")
                                .foregroundColor(.black)
                        }
                        .frame(width: 170, height: 44)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black  ,lineWidth: 2)
                    )
                }
                ZStack {
                    HStack {
                        Button(action: {
                            onSaveClick()
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                        }
                        .frame(width: 170, height: 44)
                        .background(Color.black.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }.padding(.horizontal)
                .padding(.vertical)
                .padding(.bottom,16)
        }
    }
}

struct ProfileEdit_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEdit(onSaveClick: {}, onCancelClick: {},userData: ProfileViewModel())
    }
}
