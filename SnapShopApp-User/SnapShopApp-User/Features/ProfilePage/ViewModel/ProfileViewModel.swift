//
//  ProfileViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: CustomerDetails?
    @Published var addresses: [AddressResponse]?
    @Published var addressTextFieldData: String = ""
    @Published var cityTextFieldData: String = ""
    @Published var countryTextFieldData: String = ""
    @Published var zipTextFieldData: String = ""
    @Published var phoneTextFieldData: String = ""
    
    
    static let shared:ProfileViewModel = ProfileViewModel()
    private init() {
        fetchUserById(id: "7290794967219")
        fetchUserAddresses()
        
    }
    
    func fetchUserById(id: String) {
        let url = "\(Support.baseUrl)/customers/\(id).json"
        Network.shared.request(url, method: "GET", responseType: CustomerResponse.self) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.user = user.customer
                }
            case .failure(let error):
                print("Error fetching user details: \(error)")
            }
        }
    }
    func fetchUserAddresses(customerId:String = "7290794967219"){
        let url = "\(Support.baseUrl)/customers/\(customerId)/addresses.json"
        Network.shared.request(url, method: "GET", responseType: AddressesRequest.self) { [weak self] result in
            switch result {
            case .success(let address):
                DispatchQueue.main.async {
                    self?.addresses = address.addresses
                }
            case .failure(let error):
                print("Error fetching user details: \(error)")
            }
        }
        
    }
    func postUserAddress(customerId:String = "7290794967219"){
        let address = AddressRequestToPost(customer_address: CustomerAddressToPost(id: nil, customer_id: Int(customerId), address1: addressTextFieldData, address2: nil, city: cityTextFieldData, zip: zipTextFieldData, phone: phoneTextFieldData, name: nil, province_code: nil, country_code: "EG", country_name: countryTextFieldData, default: false))
        Network.shared.postData(object: address, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers/\(customerId)/addresses.json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response.customer_address?.name)
                    self?.fetchUserAddresses()
                    
                }
            case .failure(let error):
                print("Error fetching data2: \(error)")
            }
        }
    }
    func deleteAddress(customerId:String = "7290794967219",addressId:Int){
        Network.shared.deleteObject(with: "\(Support.baseUrl)/customers/\(customerId)/addresses/\(addressId).json") { [weak self] result in
            self?.fetchUserAddresses()
            switch result{
            case .none:
                print("Success")
            case .some(let error):
                print("error is \(error.localizedDescription)")
            
            }
            print(result?.localizedDescription)
        }
    }
    
}
