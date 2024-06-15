//
//  CheckOutPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

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
    @ObservedObject var cartViewModel : CartViewModel

    var address: DraftOrderAddress
    var subTotalPrice: String
    var totalTaxes: String
    var totalPrice: String

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
                    TextField("Enter Discount code here", text: $discountCode)
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
                    Text("\(subTotalPrice) EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
                
                HStack {
                    Text("Total Taxes:").bold()
                    Text("\(totalTaxes) EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
                
                HStack {
                    Text("Total Price:").bold()
                    Text("\(totalPrice) EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom, 16)
                
                HStack {
                    Text("Price After Discounts:").bold()
                    Text("20391.49 EGP") // Update with your logic for discounted price
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
                            },
                            onCashOnDeliveryClick: {
                                showingBottomSheet.toggle()
                                print("Clicked")
                                cartViewModel.postAsCompleted()
                                // Handle order posting with cash on delivery
                            },
                            userOrders: cartViewModel.userOrders
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
            addressViewModel.getDraftOrderById()
            cartViewModel.getSpecificUserCart()
            cartViewModel.reloadView()
            discountCode =  cartViewModel.discountCodeKey ?? ""
            print("ON APPEAR")
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
