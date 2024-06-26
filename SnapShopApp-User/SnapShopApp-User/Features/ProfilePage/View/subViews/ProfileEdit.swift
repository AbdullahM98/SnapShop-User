//
//  ProfileEdit.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI
import Combine
struct ProfileEdit: View {
    var onSaveClick : (CustomerUpdateRequest) -> Void
    var onCancelClick : () -> Void
    var user: CustomerProfileDetails?
    @State var phoneTextFieldData: String = ""
    @State var firstNameTextFieldData: String = ""
    @State var secondNameTextFieldData: String = ""
    @State var emailTextFieldData: String = ""
    @State private var validationMessages: [FieldType: String] = [:]
    @State private var isFieldValid: [FieldType: Bool] = [
        .firstName: true,
        .lastName: true,
        .email: true,
        .phone: true
    ]
    
    //fore phone
    @State var presentSheet = false
    @State var countryCode : String = "+2"
    @State var countryFlag : String = "🇪🇬"
    @State var countryPattern : String = "#### ### ####"
    @State var countryLimit : Int = 17
    @State private var searchCountry: String = ""
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var keyIsFocused: Bool
    
    let counrties: [CPData] = Bundle.main.decode("CountryNumbers.json")

    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Spacer()
                Text("Edit Profile")
                    .font(.title2)
                Spacer()
            }
                .padding(.vertical,32)
            
            HStack {
                VStack(alignment: .leading){
                    Text("First Name")
                    TextField(user?.first_name ?? "First Name", text: $firstNameTextFieldData,onEditingChanged: { (isEditing) in
                        if !isEditing {
                            validateField(fieldType: .firstName, value: $firstNameTextFieldData.wrappedValue)
                        }
                    })
                        .padding(.all,8).overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFieldValid[.firstName]! ? Color.gray : Color.red, lineWidth: 1)
                        )
                    if let message = validationMessages[.firstName], !message.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                }
                VStack(alignment: .leading){
                    Text("Last Name")
                    TextField(user?.last_name ?? "Last Name", text: $secondNameTextFieldData,onEditingChanged: { (isEditing) in
                        if !isEditing {
                            validateField(fieldType: .lastName, value: $secondNameTextFieldData.wrappedValue)
                        }
                    })
                        .padding(.all,8).overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFieldValid[.lastName]! ? Color.gray : Color.red, lineWidth: 1)
                        )
                    if let message = validationMessages[.lastName], !message.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                }
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                Text("Email")
                TextField(user?.email ?? "email@example.com", text: $emailTextFieldData,onEditingChanged: { (isEditing) in
                    if !isEditing {
                        validateField(fieldType: .email, value: $emailTextFieldData.wrappedValue)
                    }
                })
                    .padding(.all,8).overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFieldValid[.email]! ? Color.gray : Color.red, lineWidth: 1)
                    ).keyboardType(.emailAddress)
                if let message = validationMessages[.email], !message.isEmpty {
                    Text(message)
                        .foregroundColor(.red)
                        .padding(.leading)
                }
            }.padding(.horizontal,16)
            VStack(alignment: .leading){
                HStack {
                    Button {
                        presentSheet = true
                        keyIsFocused = false
                    } label: {
                        Text("\(countryFlag) \(countryCode)")
                            .padding(10)
                            .frame(minWidth: 80, minHeight: 47)
                            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .foregroundColor(foregroundColor)
                    }
                    TextField("", text: $phoneTextFieldData)
                        .placeholder(when: phoneTextFieldData.isEmpty) {
                            Text("Phone number")
                                .foregroundColor(.secondary)
                        }
                        .focused($keyIsFocused)
                        .keyboardType(.numbersAndPunctuation)
                        .onReceive(Just(phoneTextFieldData)) { _ in
                            applyPatternOnNumbers(&phoneTextFieldData, pattern: countryPattern, replacementCharacter: "#")
                        }
                        .padding(10)
                        .frame(minWidth: 80, minHeight: 47)
                        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                }
                .padding(.top, 20)
                .padding(.bottom, 15)
            }.padding(.horizontal,16)
            HStack{
                ZStack {
                    HStack {
                        Button(action: {
                            onCancelClick()
                        }) {
                                Text("Cancel")
                                .foregroundColor(.black)
                                .frame(width: 170, height: 44)
                                .background(Color.white.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black  ,lineWidth: 2)
                    )
                }
                Spacer()
                ZStack {
                    HStack {
                        Button(action: {
                            if validateAllFields() {
                                
                                onSaveClick(CustomerUpdateRequest(customer: CustomerUpdateRequestBody(first_name: firstNameTextFieldData, last_name: secondNameTextFieldData, phone: phoneTextFieldData, email: emailTextFieldData))
                                    )
                            }
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                                .frame(width: 170, height: 44)
                                .background(Color.black.opacity(0.8))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }.disabled(!validateAllFields())
                    }
                }
            }.padding(.horizontal)
                .padding(.vertical)
                .padding(.bottom,16)
        }.onAppear{
            self.phoneTextFieldData = user?.phone ?? ""
            self.firstNameTextFieldData = user?.first_name ?? ""
            self.secondNameTextFieldData = user?.last_name ?? ""
            self.emailTextFieldData = user?.email ?? ""
        }
    }
    func isValidPhone(_ phone: String) -> Bool {
        // Updated regex for phone number validation
        let phoneRegEx = "^\\+201[0-9]{9}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
    func isValidEmail(_ email: String) -> Bool {
            // Simple regex for email validation
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }

    func validateField(fieldType: FieldType, value: String) {
        switch fieldType {
        case .firstName:
            if value.isEmpty {
                validationMessages[fieldType] = "name cannot be empty"
                isFieldValid[fieldType] = false
            } else {
                validationMessages[fieldType] = ""
                isFieldValid[fieldType] = true
            }
        case .lastName:
            if value.isEmpty {
                validationMessages[fieldType] = "name cant be empty"
                isFieldValid[fieldType] = false
            } else {
                validationMessages[fieldType] = ""
                isFieldValid[fieldType] = true
            }
        case .email:
            if !isValidEmail(value) {
                validationMessages[fieldType] = "Invalid email format"
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
    
    var filteredResorts: [CPData] {
        if searchCountry.isEmpty {
            return counrties
        } else {
            return counrties.filter { $0.name.contains(searchCountry) }
        }
    }
    
    var foregroundColor: Color {
        if colorScheme == .dark {
            return Color(.white)
        } else {
            return Color(.black)
        }
    }
    
    var backgroundColor: Color {
        if colorScheme == .dark {
            return Color(.systemGray5)
        } else {
            return Color(.systemGray6)
        }
    }
    
    func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringvar = pureNumber
    }
    
    
}

struct ProfileEdit_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEdit(onSaveClick: {_ in }, onCancelClick: {})
    }
}
