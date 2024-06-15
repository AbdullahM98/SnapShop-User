//
//  CheckOutPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI
import PassKit

import SwiftUI
import PassKit

struct CheckOutPage: View {
    @State private var discountCode: String = ""
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.medium
    @State private var navigateToCoupons = false
    @State private var navigateToAddresses = false
    @State private var selectedAddress: AddressProfileDetails?
    @State private var showAlert = false
    @State private var navigateToHome = false
    @ObservedObject var addressViewModel = AddressesViewModel()
    @StateObject var cartViewModel: CartViewModel
    @StateObject var newViewModel = CouponsViewModel()
    var address: DraftOrderAddress
    

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Delivery Address")
                    .bold()
                
                OrderAddressCell(address: selectedAddress ?? AddressProfileDetails(
                    id: 0,
                    customer_id: 0,
                    first_name: address.first_name,
                    last_name: address.last_name,
                    company: address.company,
                    address1: address.address1,
                    address2: address.address2,
                    city: address.city,
                    province: "",
                    country: address.country,
                    zip: address.zip,
                    phone: address.phone,
                    name: "",
                    province_code: "",
                    country_code: "",
                    country_name: "",
                    default: true
                ))
                
                NavigationLink(destination: UserAddresses(
                    viewModel: addressViewModel,
                    fromCart: true,
                    didSelectAddress: { address in
                        selectedAddress = address
                    }
                ), isActive: $navigateToAddresses) {
                    HStack {
                        Spacer()
                        AppButton(text: "Address", width: 80, height: 50, isFilled: true) {
                            print("addAddress")
                            navigateToAddresses = true
                        }
                        Spacer()
                    }
                    .padding(.bottom, 16)
                }
                
                HStack {
                    TextField("Enter Discount code here", text: $newViewModel.discountCode) // Directly bind to the discountCode property
                                            .disabled(true)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    NavigationLink(destination: CouponsPage(fromCart: true), isActive: $navigateToCoupons) {
                        AppButton(text: "Get Code", width: 90, height: 34, isFilled: true) {
                            print("apply code")
                            navigateToCoupons = true
                        }
                    }
                }
                .padding()
                
                HStack {
                    Text("Sub-Total Price:").bold()
                    Text("\(cartViewModel.userOrder?.subtotal_price ?? "0.0") EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
                
                HStack {
                    Text("Total Taxes:").bold()
                    Text("\(cartViewModel.userOrder?.total_tax ?? "0.0") EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
                
                HStack {
                    Text("Total Price:").bold()
                    Text("\(cartViewModel.userOrder?.total_price ?? "0.0") EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
                
                HStack {
                    Text("Price After Discounts:").bold()
                    Text("\(cartViewModel.userOrder?.total_price ?? "0.0") EGP") // Update with your logic for discounted price
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
                
                HStack {
                    Spacer()
                    AppButton(text: "Go To Payment", width: 120, height: 40, isFilled: true, onClick: {
                        showingBottomSheet.toggle()
                    }).sheet(isPresented: $showingBottomSheet) {
                        PaymentPage(
                            showAlert: $showAlert,
                            navigateToHome: $navigateToHome,
                            onApplePayClick: {
                                showingBottomSheet.toggle()
                                print("apple Payment")
                                cartViewModel.postAsCompleted()
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
        .navigationBarTitle("Checkout")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
        .onAppear {
            // Fetch the data here
            addressViewModel.getDraftOrderById()
            cartViewModel.getDraftOrderById()
            newViewModel.getDraftOrderById()
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
}
