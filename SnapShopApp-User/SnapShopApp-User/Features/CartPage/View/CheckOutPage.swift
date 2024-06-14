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
    @State private var navigateToCoupons = false // Flag to trigger navigation
    @State private var navigateToAddresses = false // Flag to trigger navigation
    @State private var selectedAddress: AddressProfileDetails? // Track the selected address
    @ObservedObject var addressViewModel = AddressesViewModel()
    @ObservedObject var cartViewModel = CartViewModel()
    var address:DraftOrderAddress
    var subTotalPrice: String
    var totalTaxes: String
    var totalPrice: String
    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Delivery Address")
                    .bold()
                AddressCell(address: selectedAddress ?? AddressProfileDetails(id: 0, customer_id: 0, first_name: address.first_name, last_name: address.last_name, company: address.company, address1: address.address1, address2: address.address2, city: address.city, province: "", country: address.country, zip: address.zip, phone: address.phone, name: "", province_code: "", country_code: "", country_name: "", default: true), insideCard: true, onDeleteClick: {}, onUpdateClick: {_ in})
                
                NavigationLink(destination: UserAddresses(viewModel: addressViewModel,fromCart: true, didSelectAddress: { address in
                    selectedAddress = address
                }),isActive: $navigateToAddresses) {
                    
                    HStack{
                        Spacer()
                        AppButton(text: "Address", width: 80, height: 50, isFilled: true) {
                            print("addAddress")
                            navigateToAddresses = true
                        }
                        Spacer()
                    }.padding(.bottom,16)
                }
                
                    HStack{
                        TextField("Enter Discount code here", text: $discountCode)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Spacer()
                        NavigationLink(destination: CouponsPage(), isActive: $navigateToCoupons) {
                        AppButton(text: "Get Code", width: 90, height: 34, isFilled: true) {
                            print("apply code")
                            navigateToCoupons = true
                            
                        }
                    }
                }.padding()
                HStack{
                    Text("Sub-Total Price :").bold()
                    Text("\(subTotalPrice) EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom,16)
                HStack{
                    Text("Total Taxes :").bold()
                    Text("\(totalTaxes) EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom,16)
                HStack{
                    Text("Total Price :").bold()
                    Text("\(totalPrice) EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom,16)
                HStack{
                    Text("Price After Discounts :").bold()
                    Text("20391.49 EGP")
                        .foregroundColor(.gray)
                }
                .padding(.bottom,16)
                HStack{
                    Spacer()
                    AppButton(text: "Go To Payment", width: 120, height: 40, isFilled: true, onClick: {
                        showingBottomSheet.toggle()
                    }).sheet(isPresented: $showingBottomSheet) {
                        PaymentPage(onApplePayClick: {
                            showingBottomSheet.toggle()
                            
                        }, onCashOnDeliveryClick: {
                            showingBottomSheet.toggle()
                            //post order with onCashDelivery
                        }, userOrders: cartViewModel.userOrders).presentationDetents([.medium], selection: $settingsDetents)
                    }
                    Spacer()
                }
            }
            .padding()
        }
        .navigationBarTitle("Checkout")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}
