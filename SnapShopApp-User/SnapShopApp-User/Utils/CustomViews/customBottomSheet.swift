//
//  customBottomSheet.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 11/06/2024.
//



import SwiftUI

struct CustomBottomSheetView: View {
    var onBtnClick : (() -> Void)

    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Please Login")
                .font(.title)
                .padding()
            
            Button("Login") {
                 onBtnClick()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}
