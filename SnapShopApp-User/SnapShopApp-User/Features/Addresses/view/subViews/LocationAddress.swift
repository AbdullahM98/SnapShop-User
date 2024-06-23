//
//  LocationAddress.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 22/06/2024.
//

import SwiftUI
import CoreLocation
import MapKit
import Combine


struct LocationAddress: View {
    @StateObject var locationViewModel = LocationViewModel()
    @State var address: [AddressProfileDetails]?
    @State var addressTextFieldData: String = ""
    @State var cityTextFieldData: String = ""
    @State var countryTextFieldData: String = ""
    @State var zipTextFieldData: String = ""
//    @State var phoneAddressTextFieldData: String = ""
    
    
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
    
    let counrties: [CPData] = Bundle.main.decode("CountryNumbers.json")

    
    var onSaveClick: (_ address: NewAddressRoot) -> Void
    var onCancelClick: () -> Void
    @State private var validationMessages: [FieldType: String] = [:]
    @State private var isFieldValid: [FieldType: Bool] = [
        .address: true,
        .city: true,
        .country: true,
        .phone: true
    ]
    @State private var isUsingCurrentLocation = false
    @State private var selectedLocation: IdentifiableLocation?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                    Text("Add New Address")
                        .font(.title2)
                    Spacer()
                }.padding(.top,16)
                
                VStack(alignment: .leading) {
                    Toggle("Use Current Location", isOn: $isUsingCurrentLocation)
                        .toggleStyle(SwitchToggleStyle())
                        .onChange(of: isUsingCurrentLocation) { value in
                            if value {
                                locationViewModel.requestLocation()
                            }
                        }
                    
                    if isUsingCurrentLocation {
                        Map(coordinateRegion: $locationViewModel.region,
                            interactionModes: .all,
                            showsUserLocation: true,
                            annotationItems: selectedLocation != nil ? [selectedLocation!] : []) { location in
                            MapPin(coordinate: location.coordinate, tint: .red)
                        }
                            .frame(height: 200)
                            .onTapGesture(coordinateSpace: .local) { location in
                                let coordinate = locationViewModel.region.center
                                selectedLocation = IdentifiableLocation(coordinate: coordinate)
                                reverseGeocodeAndUpdateFields(coordinate: coordinate)
                            }
                        
                        if let location = selectedLocation {
                            Text("Selected Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
                                .foregroundColor(.blue)
                        }
                    }
                    Text("Street")
                    
                    TextField("Street No.", text: $addressTextFieldData, onEditingChanged: { (isEditing) in
                        if !isEditing {
                            validateField(fieldType: .address, value: $addressTextFieldData.wrappedValue)
                        }
                    })
                    .padding(.all, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFieldValid[.address]! ? Color.gray : Color.red, lineWidth: 1)
                    )
                    
                    if let message = validationMessages[.address], !message.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                            .padding(.leading)
                    }
                    
                }
                .padding(.horizontal, 16)
                
                if !isUsingCurrentLocation {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("City")
                            TextField("Town", text: $cityTextFieldData, onEditingChanged: { (isEditing) in
                                if !isEditing {
                                    validateField(fieldType: .city, value: $cityTextFieldData.wrappedValue)
                                }
                            })
                            .padding(.all, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isFieldValid[.city]! ? Color.gray : Color.red, lineWidth: 1)
                            )
                            
                            if let message = validationMessages[.city], !message.isEmpty {
                                Text(message)
                                    .foregroundColor(.red)
                                    .padding(.leading)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Country")
                            TextField("Egypt", text: $countryTextFieldData, onEditingChanged: { (isEditing) in
                                if !isEditing {
                                    validateField(fieldType: .country, value: $countryTextFieldData.wrappedValue)
                                }
                            })
                            .padding(.all, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(isFieldValid[.country]! ? Color.gray : Color.red, lineWidth: 1)
                            )
                            
                            if let message = validationMessages[.country], !message.isEmpty {
                                Text(message)
                                    .foregroundColor(.red)
                                    .padding(.leading)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                } else {
                    VStack(alignment: .leading) {
                        Text("City")
                        TextField("City", text: $locationViewModel.cityString)
                            .padding(.all, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                        
                        Text("Country")
                        TextField("Country", text: $locationViewModel.countryString)
                            .padding(.all, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 16)
                }
                
                VStack(alignment: .leading) {
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
                        TextField("", text: $mobPhoneNumber)
                            .placeholder(when: mobPhoneNumber.isEmpty) {
                                Text("Phone number")
                                    .foregroundColor(.secondary)
                            }
                            .focused($keyIsFocused)
                            .keyboardType(.numbersAndPunctuation)
                            .onReceive(Just(mobPhoneNumber)) { _ in
                                applyPatternOnNumbers(&mobPhoneNumber, pattern: countryPattern, replacementCharacter: "#")
                            }
                            .padding(10)
                            .frame(minWidth: 80, minHeight: 47)
                            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 15)
                    /*
                    Text("Phone Number")
                    TextField("+20 XXXX XXX XXX", text: $phoneAddressTextFieldData, onEditingChanged: { (isEditing) in
                        if !isEditing {
                            validateField(fieldType: .phone, value: $phoneAddressTextFieldData.wrappedValue)
                        }
                    })
                    .padding(.all, 8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFieldValid[.phone]! ? Color.gray : Color.red, lineWidth: 1)
                    )
                    .keyboardType(.phonePad)
                    
                    if let message = validationMessages[.phone], !message.isEmpty {
                        Text(message)
                            .foregroundColor(.red)
                            .padding(.leading)
                    }*/
                }
                .padding(.horizontal, 16)
                
                VStack(alignment: .leading) {
                    Text("Zip Code")
                    TextField("6789", text: $zipTextFieldData)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding(.horizontal, 16)
                
                HStack {
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
                            .stroke(Color.black, lineWidth: 2)
                    )
                    
                    Spacer()
                    
                    if validateAllFields() {
                        Button(action: {
                            if validateAllFields() {
                                let newAddress = NewAddressRoot(
                                    customer_address: NewAddressDetails(
                                        id: nil,
                                        customer_id: UserDefaultsManager.shared.getUserId(key: Support.userID),
                                        address1: isUsingCurrentLocation ? locationViewModel.addressString : addressTextFieldData,
                                        address2: nil,
                                        city: isUsingCurrentLocation ? locationViewModel.cityString : cityTextFieldData,
                                        zip: zipTextFieldData,
                                        phone: mobPhoneNumber,
                                        name: nil,
                                        province_code: nil,
                                        country_code: "EG",
                                        country_name: isUsingCurrentLocation ? locationViewModel.countryString : countryTextFieldData,
                                        default: false
                                    )
                                )
                                onSaveClick(newAddress)
                            }
                        }) {
                            Text("Save")
                                .foregroundColor(.white)
                                .frame(width: 170, height: 44)
                                .background(Color.black.opacity(0.9))
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                        }
                        .disabled(!validateAllFields())
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 4)
                .padding(.bottom, 16)
            }
            
            .sheet(isPresented: $presentSheet) {
                NavigationView {
                    List(filteredResorts) { country in
                        HStack {
                            Text(country.flag)
                            Text(country.name)
                                .font(.headline)
                            Spacer()
                            Text(country.dial_code)
                                .foregroundColor(.secondary)
                        }
                        .onTapGesture {
                            self.countryFlag = country.flag
                            self.countryCode = country.dial_code
                            self.countryPattern = country.pattern
                            self.countryLimit = country.limit
                            presentSheet = false
                            searchCountry = ""
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchCountry, prompt: "Your country")
                }
                .presentationDetents([.medium, .large])
            }
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
                validationMessages[fieldType] = "City cannot be empty"
                isFieldValid[fieldType] = false
            } else {
                validationMessages[fieldType] = ""
                isFieldValid[fieldType] = true
            }
        case .country:
            if value.isEmpty {
                validationMessages[fieldType] = "Country cannot be empty"
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
        default:
            break
        }
    }
    
    func validateAllFields() -> Bool {
        return isFieldValid.values.allSatisfy { $0 }
    }
    
    func isValidPhone(_ phone: String) -> Bool {
        let phoneRegEx = "^\\+201[0-9]{9}$"
        let phonePred = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePred.evaluate(with: phone)
    }
    
    func reverseGeocodeAndUpdateFields(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else { return }
            addressTextFieldData = placemark.thoroughfare ?? "No Specific Address"
            cityTextFieldData = placemark.locality ?? ""
            countryTextFieldData = placemark.country ?? ""
            
            if isUsingCurrentLocation {
                locationViewModel.addressString = placemark.thoroughfare ?? ""
                locationViewModel.cityString = placemark.locality ?? ""
                locationViewModel.countryString = placemark.country ?? ""
            }
        }
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

struct LocationAddress_Previews: PreviewProvider {
    static var previews: some View {
        LocationAddress(onSaveClick: { address in }, onCancelClick: {})
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}
extension View {
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
}
struct OnboardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous )
                .frame(height: 49)
                .foregroundColor(Color(.systemBlue))
            
            configuration.label
                .fontWeight(.semibold)
                .foregroundColor(Color(.white))
        }
    }
}
