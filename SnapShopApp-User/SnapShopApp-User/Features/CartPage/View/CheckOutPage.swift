//
//  CheckOutPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI
import PassKit

struct CheckOutPage: View {
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.medium
    @State private var navigateToCoupons = false
    @State private var navigateToAddresses = false
    @State private var selectedAddress: AddressProfileDetails?
    @State private var showAlert = false
    @State private var navigateToHome = false
    @StateObject var cartViewModel = CartViewModel()
    @State private var discountCode: String = "" // Use a state variable to hold the discount code
    var body: some View {
        VStack{
            if cartViewModel.isCheckOutLoading {
                Spacer()
                
                LottieView(animationFileName: "ShoppingAnimation", loopMode: .loop)
                    .frame(width: 200, height: 200)
                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Delivery Address")
                            .bold()
                        OrderAddressCell(address: selectedAddress ?? AddressProfileDetails(
                            id: 0,
                            customer_id: 0,
                            first_name: cartViewModel.shippingAddress?.first_name,
                            last_name: cartViewModel.shippingAddress?.last_name,
                            company: cartViewModel.shippingAddress?.company,
                            address1: cartViewModel.shippingAddress?.address1,
                            address2: cartViewModel.shippingAddress?.address2,
                            city: cartViewModel.shippingAddress?.city,
                            province: cartViewModel.shippingAddress?.province,
                            country: cartViewModel.shippingAddress?.country,
                            zip: cartViewModel.shippingAddress?.zip,
                            phone: cartViewModel.shippingAddress?.phone,
                            name: cartViewModel.shippingAddress?.name,
                            province_code: cartViewModel.shippingAddress?.province_code,
                            country_code: cartViewModel.shippingAddress?.country_code,
                            country_name: "",
                            default: false
                        ))
                        
                        NavigationLink(destination: UserAddresses(
                            fromCart: true, didSelectAddress: { address in
                                selectedAddress = address
                            }
                        ), isActive: $navigateToAddresses) {
                            HStack {
                                Spacer()
                                AppButton(text: "Select Address", width: UIScreen.screenWidth * 0.9, height: 40, isFilled: true) {
                                    print("addAddress")
                                    navigateToAddresses = true
                                }
                                Spacer()
                            }
                            .padding(.bottom, 16)
                        }
                        
                        HStack {
                            TextField("Enter Discount code here", text: $discountCode) // Directly bind to the discountCode property
                                .disabled(true)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Spacer()
                            NavigationLink(destination: CouponsPage(fromCart: true), isActive: $navigateToCoupons) {
                                AppButton(text: discountCode != "" ? "ApplyCode":"Get Code", width: 90, height: 34, isFilled: true) {
                                    if discountCode != "" {
                                        print("Update Draft Order")
                                        if let priceRuleId = UserDefaultsManager.shared.priceRuleIdForCoupon{
                                            cartViewModel.fetchPriceRulesByIdForApplyingCoupons(id: priceRuleId)
                                        }
                                    } else {
                                        print("navigate")
                                        navigateToCoupons = true
                                    }
                                }
                            }
                        }
                        .padding()
                        
                        HStack {
                            Text("Sub-Total Price:").bold()
                            if let subtotalPrice = cartViewModel.userOrder?.subtotal_price,
                               let discountValue = cartViewModel.userOrder?.applied_discount?.value {
                                let originalPrice = calculateOriginalPrice(afterDiscount: Double(subtotalPrice) ?? 0.0, discountRate: Double(discountValue) ?? 0.0)
                                
                                Text("\(String(format: "%.2f",originalPrice * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                    .foregroundColor(.gray)
                                //                        Text("\(String(format: "%.2f", originalPrice)) EGP")                        .foregroundColor(.gray)
                                
                            } else {
                                
                                Text("\(String(format: "%.2f",(Double(cartViewModel.userOrder?.subtotal_price ?? "1.0" ) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 16)
                        
                        HStack {
                            Text("Total Taxes:").bold()
                            if let totalTax = cartViewModel.userOrder?.total_tax,
                               let discountValue = cartViewModel.userOrder?.applied_discount?.value {
                                let originalPrice = calculateOriginalPrice(afterDiscount: Double(totalTax) ?? 0.0, discountRate: Double(discountValue) ?? 0.0)
                                //                        Text("\(String(format: "%.2f", originalPrice)) EGP")
                                Text("\(String(format: "%.2f", originalPrice  * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                    .foregroundColor(.red)
                                
                            } else {
                                
                                Text("\(String(format: "%.2f",(Double(cartViewModel.userOrder?.total_tax ?? "1.0" ) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                    .foregroundColor(.gray)
                                //                        Text("\(cartViewModel.userOrder?.total_tax ?? "0.0")  \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 16)
                        
                        HStack {
                            Text("Total Price:").bold()
                            if let totalPrice = cartViewModel.userOrder?.total_price,
                               let discountValue = cartViewModel.userOrder?.applied_discount?.value {
                                let originalPrice = calculateOriginalPrice(afterDiscount: Double(totalPrice) ?? 0.0, discountRate: Double(discountValue) ?? 0.0)
                                Text("\(String(format: "%.2f",originalPrice  * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                    .foregroundColor(.gray)
                                //                        Text("\(String(format: "%.2f", originalPrice)) EGP")                        .foregroundColor(.gray)
                                
                            } else {
                                
                                Text("\(String(format: "%.2f",(Double(cartViewModel.userOrder?.total_price ?? "1.0" ) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                    .foregroundColor(.gray)
                                //                        Text("\(cartViewModel.userOrder?.total_price ?? "0.0")  \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                //                            .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom, 16)
                        
                        HStack {
                            Text("Price After Discounts:").bold()
                            
                            Text("\(String(format: "%.2f",(Double(cartViewModel.userOrder?.total_price ?? "1.0" ) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                .foregroundColor(.green)
                            //                    Text("\(cartViewModel.userOrder?.total_price ?? "0.0") EGP").foregroundColor(.green) // Update with your logic for discounted price
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 16)
                        
                        HStack {
                            Spacer()
                            AppButton(text: "Go To Payment", width: UIScreen.screenWidth * 0.9, height: 40, isFilled: true, onClick: {
                                showingBottomSheet.toggle()
                            }).sheet(isPresented: $showingBottomSheet) {
                                PaymentPage(
                                    showAlert: $showAlert,
                                    navigateToHome: $navigateToHome,
                                    onApplePayClick: {
                                        showingBottomSheet.toggle()
                                        print("apple Payment")
                                    },
                                    onCashOnDeliveryClick: {
                                        showingBottomSheet.toggle()
                                        print("CashOnDelivery")
                                        cartViewModel.postAsCompleted()
                                        // Handle order posting with cash on delivery
                                    },
                                    userOrders: cartViewModel.userOrder ?? DraftOrderItemDetails(id: 0, note: "", email: "", taxes_included: false, currency: "", invoice_sent_at: "", created_at: "", updated_at: "", tax_exempt: false, completed_at: "", name: "", status: "", billing_address: nil, invoice_url: "", order_id: 0, shipping_line: "", tax_lines: nil, tags: "", note_attributes: nil, total_price: "", subtotal_price: "", total_tax: "", payment_terms: "", presentment_currency: "", admin_graphql_api_id: "", customer: nil, use_customer_default_address: true)
                                ).presentationDetents([.medium], selection: $settingsDetents)
                            }
                            Spacer()
                        }
                    }
                    .padding()
                }
            }
            
        }
        .navigationBarTitle("Checkout")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .onAppear {
            // Fetch the data here
            print("Appear again")
            cartViewModel.getDraftOrderById()
            // Fetch discount code from UserDefaults
            if let savedDiscountCode = UserDefaultsManager.shared.selectedCouponCodeValue {
                self.discountCode = savedDiscountCode
            }
        }
        .overlay(
            showAlert ? AnyView(
                ImageButtonAlert(
                    isPresented: $showAlert,
                    title: "Congratulations",
                    message: "Your order is under preparation",
                    image: Image("congratulations"),
                    buttonText: "Continue Shopping",
                    onAction: {
                        cartViewModel.postAsCompleted()
                        showAlert = false
                        navigateToHome = true
                    }
                )
            ) : AnyView(EmptyView())
        )
        .background(
            NavigationLink(
                destination: ContentView(), // Replace with your actual home view
                isActive: $navigateToHome,
                label: { EmptyView() }
            )
        )
    }
    func calculateOriginalPrice(afterDiscount priceAfterDiscount: Double, discountRate: Double) -> Double {
        return priceAfterDiscount / (1 - discountRate/100)
    }
    
}

