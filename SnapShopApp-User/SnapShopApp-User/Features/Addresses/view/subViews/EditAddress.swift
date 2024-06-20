//
//  EditAddress.swift
//  SnapShopApp-User
//
//  Created by husayn on 11/06/2024.
//

import SwiftUI

struct EditAddress: View {
    var onSaveClick : (AddressForUpdate) -> Void
    var onCancelClick : () -> Void
    var customerAddress: AddressProfileDetails?
    @State var addressEdit: String = ""
    @State var cityEdit: String = ""
    @State var countryEdit: String = ""
    @State var zipEdit: String = ""
    @State var phoneAddressEdit: String = ""
    @State private var validationMessages: [FieldType: String] = [:]
    @State private var isFieldValid: [FieldType: Bool] = [
        .address: true,
        .city: true,
        .country: true,
        .phone: true
    ]
    @State private var showingEditAlert = false

    var body: some View {
        VStack(alignment: .leading,spacing: 8){
            HStack{
                Spacer()
                Text("Edit Address")
                    .font(.title2)
                Spacer()
            }
            VStack(alignment: .leading){
                Text("Address")
                    .padding(.top,4)
                TextField( customerAddress?.address1 ?? "Street No.", text: $addressEdit,onEditingChanged: { (isEditing) in
                    if !isEditing {
                        validateField(fieldType: .address, value: $addressEdit.wrappedValue)
                    }
                }).padding(.all,8).overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFieldValid[.address]! ? Color.gray : Color.red, lineWidth: 1)
                )
                if let message = validationMessages[.address], !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }.padding(.horizontal,16)
            HStack {
                VStack(alignment: .leading){
                    Text("City")
                    TextField(customerAddress?.city ?? "Example", text: $cityEdit,onEditingChanged: { (isEditing) in
                        if !isEditing {
                            validateField(fieldType: .city, value: $cityEdit.wrappedValue)
                        }
                    })
                        .padding(.all,8).overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFieldValid[.city]! ? Color.gray : Color.red, lineWidth: 1)
                        )
                    if let message = validationMessages[.city], !message.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                }
                VStack(alignment: .leading){
                    Text("Country")
                    TextField(customerAddress?.country ?? "Example", text: $countryEdit,onEditingChanged: { (isEditing) in
                        if !isEditing {
                            validateField(fieldType: .country, value: $countryEdit.wrappedValue)
                        }
                    })
                        .padding(.all,8).overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFieldValid[.country]! ? Color.gray : Color.red, lineWidth: 1)
                        )
                    if let message = validationMessages[.country], !message.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                }
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Phone Number")
                TextField(customerAddress?.phone ?? "+20 XXXX XXX XXX", text: $phoneAddressEdit,onEditingChanged: { (isEditing) in
                    if !isEditing {
                        validateField(fieldType: .phone, value: $phoneAddressEdit.wrappedValue)
                    }
                })
                    .padding(.all,8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFieldValid[.phone]! ? Color.gray : Color.red, lineWidth: 1)
                    ).keyboardType(.phonePad)
                if let message = validationMessages[.phone], !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Zip Code")
                TextField(customerAddress?.zip ?? "6789", text: $zipEdit)
                    .padding(.all,8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray , lineWidth: 1)
                    )                    .keyboardType(.numberPad)
            }.padding(.horizontal,16)
            HStack{
                Button(action: {
                    onCancelClick()
                }) {
                    Text("Cancel")
                        .frame(width: 170, height: 44)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.black  ,lineWidth: 2)
                )
                Spacer()
                Button(action: {
                    if validateAllFields() {
                        showingEditAlert = true
                        
                    }
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                        .frame(width: 170, height: 44)
                        .background(Color.black.opacity(0.9))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }.disabled(!validateAllFields())
                    .alert(isPresented: $showingEditAlert) {
                        Alert(
                            title: Text("Update Confirmation"),
                            message: Text("Are you sure to update this address?"),
                            primaryButton: .default(Text("Update"), action: {
                                onSaveClick(AddressForUpdate(customer_address: AddressProfileDetails(id: customerAddress?.id, customer_id: customerAddress?.customer_id, first_name: customerAddress?.first_name, last_name: customerAddress?.last_name, company: customerAddress?.company, address1: addressEdit, address2: customerAddress?.address2, city: cityEdit, province: customerAddress?.province, country: countryEdit, zip: zipEdit, phone: phoneAddressEdit, name: customerAddress?.name, province_code: customerAddress?.province_code, country_code: customerAddress?.country_code, country_name: customerAddress?.country_name, default: false)))
                                showingEditAlert = false
                            }),
                            secondaryButton: .cancel(Text("Cancel"), action: {
                                showingEditAlert = false
                            })
                        )
                    }
            }.padding(.horizontal)
                .padding(.vertical,4)
                .padding(.bottom,16)
        }.onAppear{
            self.addressEdit = customerAddress?.address1 ?? ""
            self.cityEdit = customerAddress?.city ?? ""
            self.countryEdit = customerAddress?.country ?? ""
            self.phoneAddressEdit = customerAddress?.phone ?? ""
            self.zipEdit = customerAddress?.zip ?? ""
        }
    }
    func validateField(fieldType: FieldType, value: String) {
        switch fieldType {
        case .address:
            if value.isEmpty {
                validationMessages[fieldType] = "Address cannot be empty"
                isFieldValid[fieldType] = false
            } else {
                validationMessages[fieldType] = ""
                isFieldValid[fieldType] = true
            }
        case .city:
            if value.isEmpty {
                validationMessages[fieldType] = "City cant be empty"
                isFieldValid[fieldType] = false
            } else {
                validationMessages[fieldType] = ""
                isFieldValid[fieldType] = true
            }
        case .country:
            if value.isEmpty {
                validationMessages[fieldType] = "Country cant be empty"
                isFieldValid[fieldType] = false
            } else {
                validationMessages[fieldType] = ""
                isFieldValid[fieldType] = true
            }
        case .phone:
            if !isValidPhone(value) {
                validationMessages[fieldType] = "Start with +2 then 11 numbers"
                isFieldValid[fieldType] = false
            } else {
                validationMessages[fieldType] = ""
                isFieldValid[fieldType] = true
            }
        default :
            break
        }
    }
    
    func validateAllFields() -> Bool {
        return  isFieldValid.values.allSatisfy{ $0 }
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        // Updated regex for phone number validation
        let phoneRegEx = "^\\+201[0-9]{9}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }


}

struct EditAddress_Previews: PreviewProvider {
    static var previews: some View {
        EditAddress(onSaveClick: {_ in }, onCancelClick: {})
    }
}
