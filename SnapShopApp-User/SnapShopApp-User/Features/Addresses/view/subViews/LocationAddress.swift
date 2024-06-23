//
//  LocationAddress.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 22/06/2024.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationAddress: View {
    @StateObject var locationViewModel = LocationViewModel()
    @State var address: [AddressProfileDetails]?
    @State var addressTextFieldData: String = ""
    @State var cityTextFieldData: String = ""
    @State var countryTextFieldData: String = ""
    @State var zipTextFieldData: String = ""
    @State var phoneAddressTextFieldData: String = ""
    
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
                    }
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
                                        phone: phoneAddressTextFieldData,
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
}

struct LocationAddress_Previews: PreviewProvider {
    static var previews: some View {
        LocationAddress(onSaveClick: { address in }, onCancelClick: {})
    }
}
