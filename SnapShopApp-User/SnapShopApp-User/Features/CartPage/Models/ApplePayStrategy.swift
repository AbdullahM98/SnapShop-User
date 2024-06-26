//
//  ApplePayStrategy.swift
//  SnapShopApp-User
//
//  Created by husayn on 14/06/2024.
//

import Foundation
import PassKit
import SwiftUI
class ApplePayStrategy: NSObject, PKPaymentAuthorizationControllerDelegate {
    var userOrders: DraftOrderItemDetails
    var onApplePayClick: () -> Void
    var showAlertWithImage: ((String, String, Image, String, @escaping () -> Void) -> Void)?
    var button = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .automatic)
    var lineItems: [DraftOrderLineItem] = []

    init(userOrder: DraftOrderItemDetails,onApplePayClick: @escaping () -> Void,showAlertWithImage: @escaping (String, String, Image, String, @escaping () -> Void) -> Void) {
        self.userOrders = userOrder
        self.showAlertWithImage = showAlertWithImage
        self.onApplePayClick = onApplePayClick
        super.init()
        button.addTarget(self, action: #selector(callBack(_:)), for: .touchUpInside)
        lineItems = self.userOrders.line_items ?? []
    }
    
    @objc func callBack(_ sender: Any) {
        startPayment(userOrders: userOrders)
    }
    
    func startPayment(userOrders: DraftOrderItemDetails) {
        var paymentController: PKPaymentAuthorizationController?
        var paymentSummaryItems = [PKPaymentSummaryItem]()
        
        lineItems.forEach { lineItem in
            print("Price is ",((Double(lineItem.price ?? "0.0") ?? 1) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1)))
            let amount = ceil(Double(lineItem.price ?? "0.0") ?? 0.0) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1.0") ?? 1.0)
            print(" amount is \(amount)")
            let item = PKPaymentSummaryItem(label: lineItem.name ?? "", amount: NSDecimalNumber(string: "\(String(format: "%.0f", amount))"), type: .final)
            paymentSummaryItems.append(item)
        }
        
//        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(userOrders.total_price ?? "0.0")"), type: .final)
        let totalAmount = ceil(Double(userOrders.total_price ?? "1.0" ) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1)
        let total = PKPaymentSummaryItem(label: "Total", amount: NSDecimalNumber(string: "\(String(format: "%.0f", totalAmount))"), type: .final)
        
        
        paymentSummaryItems.append(total)
        
        var paymentRequest = PKPaymentRequest()
        
        paymentRequest.paymentSummaryItems = paymentSummaryItems
        paymentRequest.countryCode = "EG"
        paymentRequest.currencyCode = UserDefaultsManager.shared.selectedCurrencyCode ?? "USD"
        
        paymentRequest.supportedNetworks = [.visa, .masterCard, .mada]
        paymentRequest.shippingType = .delivery
        paymentRequest.merchantIdentifier = "merchant.SnapShopApp-User"
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.shippingMethods = shippingMethodCalculator()
        
        let contact = PKContact()
        var name = PersonNameComponents()
        name.givenName = userOrders.customer?.first_name
        name.familyName = userOrders.customer?.last_name
        contact.name = name
        contact.phoneNumber = CNPhoneNumber(stringValue: userOrders.customer?.phone ?? "")
        paymentRequest.shippingContact = contact
        
        paymentRequest.requiredShippingContactFields = [.name, .phoneNumber]
        paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        paymentController?.delegate = self
        paymentController?.present()
    }
    
    func shippingMethodCalculator() -> [PKShippingMethod] {
        let today = Date()
        let calendar = Calendar.current
        let shippingStart = calendar.date(byAdding: .day, value: 5, to: today)
        let shippingEnd = calendar.date(byAdding: .day, value: 10, to: today)
        
        if let shippingEnd = shippingEnd, let shippingStart = shippingStart {
            let startComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingStart)
            let endComponents = calendar.dateComponents([.calendar, .year, .month, .day], from: shippingEnd)
            let shippingDelivery = PKShippingMethod(label: "Delivery", amount: NSDecimalNumber(string: "0.0"))
            shippingDelivery.dateComponentsRange = PKDateComponentsRange(start: startComponents, end: endComponents)
            shippingDelivery.detail = "We hope you enjoy our service"
            shippingDelivery.identifier = "DELIVERY"
            return [shippingDelivery]
        }
        return []
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment) async -> PKPaymentAuthorizationResult {
        print("Here to post order and to delete draft")

        // Call the closure to show the alert with the image
        showAlertWithImage?(
            "Congratulations",
            "Your order is under preparation",
            Image("congratulations"),
            "Continue Shopping"
        ) {
            // Perform any actions needed when the button in the alert is pressed
        }
        print("NotHere To PostOrder")

        return .init(status: .success, errors: nil)
    }
    
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        print("Here to post order")
        onApplePayClick()
        controller.dismiss()
    }
}
