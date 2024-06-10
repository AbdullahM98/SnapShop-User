//
//  CheckOutPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI

struct CheckOutPage: View {
    @State private var discountCode: String = ""
    @State private var showingBottomSheet = false
    @State private var settingsDetents = PresentationDetent.medium
    @State private var navigateToCoupons = false // Flag to trigger navigation
    @State private var navigateToAddresses = false // Flag to trigger navigation
    @State private var selectedAddress: AddressProfileDetails? // Track the selected address

    var body: some View {
        ScrollView{
            VStack(alignment: .leading){
                Text("Delivery Address")
                    .bold()
                AddressCell(address: selectedAddress ?? AddressProfileDetails(id: 0, customer_id: 0, first_name: "", last_name: "", company: "", address1: "", address2: "", city: "", province: "", country: "", zip: "", phone: "", name: "", province_code: "", country_code: "", country_name: "", default: true), insideCard: true, onDeleteClick: {})
                
                NavigationLink(destination: UserAddresses(fromCart: true, didSelectAddress: { address in
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
                    Text("Total Price :").bold()
                    Text("20391.49 EGP")
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
                        }).presentationDetents([.medium], selection: $settingsDetents)
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

struct CheckOutPage_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutPage()
        
    }
}
