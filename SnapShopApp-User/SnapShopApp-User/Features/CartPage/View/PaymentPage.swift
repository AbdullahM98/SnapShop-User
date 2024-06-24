//
//  PaymentPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI

struct PaymentPage: View {
    @Binding var showAlert: Bool
    @Binding var navigateToHome: Bool
    var onApplePayClick: () -> Void
    var onCashOnDeliveryClick: () -> Void
    var userOrders: DraftOrderItemDetails
    @ObservedObject var networkMonitor = NetworkMonitor()

    @AppStorage("isDarkMode") private var isDarkMode = false


    var body: some View {
        if !networkMonitor.isConnected {
           NetworkUnavailableView()
        }else{
        VStack(alignment: .leading) {
            
            HStack {
                Spacer()
                Image("payment")
                Spacer()
            }
            .padding(.bottom, 32)
            .padding(.top, 16)
            
            Text("Apple pay - convenient, secure and confidential way of payments")
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading) {
                Text("Payment Method")
                    .padding(.top, 64)
                    .font(.title2)
                
                ApplePayButton(showAlert: $showAlert, navigateToHome: $navigateToHome, onApplePayClick: onApplePayClick, userOrders: userOrders)
                    .frame(minWidth: 100, maxWidth: .infinity, maxHeight: 45)
                    .padding()
                
                ButtonWithImage(
                    showAlert: $showAlert,
                    text: "Cash On Delivery",
                    imageName: "bag",
                    textColor: .white,
                    buttonColor: isDarkMode ? Color.white : Color.black,
                    borderColor: isDarkMode ? Color.white :  Color.black,
                    imageExist: false,
                    onClick: onCashOnDeliveryClick
                )
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 8)
    }
    }
}

struct ApplePayButton: UIViewRepresentable {
    @Binding var showAlert: Bool
    @Binding var navigateToHome: Bool
    var onApplePayClick: () -> Void

    var userOrders: DraftOrderItemDetails

    func makeCoordinator() -> ApplePayStrategy {
        ApplePayStrategy(userOrder: userOrders, onApplePayClick: onApplePayClick, showAlertWithImage: { title, message, image, buttonText, onAction in
            showAlert = true
            // You can add additional actions if needed
            onAction() // This will be called after the alert is shown
        })
    }

    func makeUIView(context: Context) -> some UIView {
        return context.coordinator.button
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        context.coordinator.userOrders = userOrders
    }
}
