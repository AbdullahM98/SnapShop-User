//
//  TwoButtonsAlert.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 14/06/2024.
//

import SwiftUI

struct TwoButtonAlert: View {
    var title: String
    var message: String
    var confirmButtonText: String
    var cancelButtonText: String
    var onConfirm: () -> Void
    var onCancel: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)

            HStack(spacing: 20) {
                Button(action: onCancel) {
                    Text(cancelButtonText)
                        .frame(minWidth: 100)
                        .padding()
                        .background(Color.offWhite2)
                        .foregroundColor(.red)
                        .cornerRadius(8)
                }

                Button(action: onConfirm) {
                    Text(confirmButtonText)
                        .frame(minWidth: 100)
                        .padding()
                        .background(Color.offWhite2)
                        .foregroundColor(.green)
                        .cornerRadius(8)
                }
            }
        }
        .frame(width: UIScreen.screenWidth - 100)
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding(.horizontal, 40)
    }
}


struct TwoButtonAlert_Previews: PreviewProvider {
    static var previews: some View {
        TwoButtonAlert(title: "Deleting", message: "Are you sure you want to delete this item?",confirmButtonText: "YES",cancelButtonText: "NO", onConfirm: {},onCancel: {})
    }
}

//first add your view in ZStack{}



//second add this property
//    @State private var showAlert = false



// third add this in the view in the same level of the stack that is inside the ZStack
//if showAlert {
//    ZStack {
//        Color.black.opacity(0.4)
//            .edgesIgnoringSafeArea(.all)
//
//        CustomAlert(title: "Delete Item",
//                    message: "Are you sure you want to delete this item from your cart?",
//                    onDismiss: {
                // put what you want to handle here
//            showAlert = false
//        })
//        .transition(.scale)
//        .zIndex(1)
//    }
//    .animation(.easeInOut, value: showAlert)
//}

