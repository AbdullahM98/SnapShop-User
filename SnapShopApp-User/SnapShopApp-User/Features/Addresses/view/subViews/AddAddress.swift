//
//  AddAddress.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct AddAddress: View {
    @State var address: [AddressProfileDetails]?
    @State var addressTextFieldData: String = ""
    @State var cityTextFieldData: String = ""
    @State var countryTextFieldData: String = ""
    @State var zipTextFieldData: String = ""
    @State var phoneAddressTextFieldData: String = ""
    
    //fore phone
    @State var presentSheet = false
    @State var countryCode : String = "+2"
    @State var countryFlag : String = "🇪🇬"
    @State var countryPattern : String = "#### ### ####"
    @State var countryLimit : Int = 17
    @State var mobPhoneNumber = ""
    @State private var searchCountry: String = ""
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var keyIsFocused: Bool
    private var isValid: Bool {
        !addressTextFieldData.isEmpty && !cityTextFieldData.isEmpty && !countryTextFieldData.isEmpty && !phoneAddressTextFieldData.isEmpty
     
    }
    
    let counrties: [CPData] = Bundle.main.decode("CountryNumbers.json")

    
    var onSaveClick : (_ address:NewAddressRoot) -> Void
    var onCancelClick : () -> Void
    @State private var validationMessages: [FieldType: String] = [:]
    @State private var isFieldValid: [FieldType: Bool] = [
        .address: true,
        .city: true,
        .country: true,
        .phone: true
    ]
    var body: some View {
        VStack(alignment: .leading,spacing: 8){
            HStack{
                Spacer()
                Text("Add New Address")
                    .font(.title2)
                Spacer()
            }
            VStack(alignment: .leading){
                Text("Address")
                    .padding(.top,4)
                TextField("Street No.", text: $addressTextFieldData,onEditingChanged: { (isEditing) in
                    if !isEditing {
                        validateField(fieldType: .address, value: $addressTextFieldData.wrappedValue)
                    }
                })
                    .padding(.all,8).overlay(
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
                    TextField("Town", text: $cityTextFieldData,onEditingChanged: { (isEditing) in
                        if !isEditing {
                            validateField(fieldType: .city, value: $cityTextFieldData.wrappedValue)
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
                    TextField("Egypt", text: $countryTextFieldData,onEditingChanged: { (isEditing) in
                        if !isEditing {
                            validateField(fieldType: .country, value: $countryTextFieldData.wrappedValue)
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
                TextField("+20 XXXX XXX XXX", text: $phoneAddressTextFieldData,onEditingChanged: { (isEditing) in
                    if !isEditing {
                        validateField(fieldType: .phone, value: $phoneAddressTextFieldData.wrappedValue)
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
                TextField("6789", text: $zipTextFieldData)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
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
                        if isValid {
                            onSaveClick(NewAddressRoot(customer_address: NewAddressDetails(id: nil, customer_id: UserDefaultsManager.shared.getUserId(key: Support.userID), address1: addressTextFieldData, address2: nil, city: cityTextFieldData, zip: zipTextFieldData, phone: phoneAddressTextFieldData, name: nil, province_code: nil, country_code: "EG", country_name: countryTextFieldData, default: false)))
                        }else{
                            SnackBarHelper.showSnackBar(message: "All fields are required", color: Color.red.opacity(0.8))
                        }
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .frame(width: 170, height: 44)
                            .background(Color.black.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }.disabled(!isValid)
                
            }.padding(.horizontal)
                .padding(.vertical,4)
                .padding(.bottom,16)
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

struct AddAddress_Previews: PreviewProvider {
    static var previews: some View {
        AddAddress(onSaveClick: {address in }, onCancelClick: {})
    }
}


