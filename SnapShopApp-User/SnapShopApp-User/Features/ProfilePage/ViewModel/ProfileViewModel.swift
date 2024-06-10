//
//  ProfileViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: CustomerProfileDetails?
    @Published var addresses: [AddressProfileDetails]?
    @Published var addressTextFieldData: String = ""
    @Published var cityTextFieldData: String = ""
    @Published var countryTextFieldData: String = ""
    @Published var zipTextFieldData: String = ""
    @Published var phoneTextFieldData: String = ""
    @Published var phoneAddressTextFieldData: String = ""
    @Published var firstNameTextFieldData: String = ""
    @Published var secondNameTextFieldData: String = ""
    @Published var emailTextFieldData: String = ""
    @Published var orderList : [Order] = []
    
    
    
    static let shared:ProfileViewModel = ProfileViewModel()
    private init() {
        fetchUserById(id: "7290794967219")
        fetchUserAddresses()
        fetchCompletedOrders(customerId: "7290794967219")
    }
    
    func fetchUserById(id: String) {
        let url = "\(Support.baseUrl)/customers/\(id).json"
        Network.shared.request(url, method: "GET", responseType: CustomerProfileRoot.self) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.user = user.customer
                    self?.emailTextFieldData = self?.user?.email ?? ""
                    self?.firstNameTextFieldData = self?.user?.first_name ?? ""
                    self?.secondNameTextFieldData = self?.user?.last_name ?? ""
                    self?.phoneTextFieldData = self?.user?.phone ?? ""
                    
                }
            case .failure(let error):
                print("Error fetching user details: \(error)")
            }
        }
    }
    func fetchUserAddresses(customerId:String = "7290794967219"){
        let url = "\(Support.baseUrl)/customers/\(customerId)/addresses.json"
        Network.shared.request(url, method: "GET", responseType: AddressProfileRoot.self) { [weak self] result in
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
        let address = NewAddressRoot(customer_address: NewAddressDetails(id: nil, customer_id: Int(customerId), address1: addressTextFieldData, address2: nil, city: cityTextFieldData, zip: zipTextFieldData, phone: phoneTextFieldData, name: nil, province_code: nil, country_code: "EG", country_name: countryTextFieldData, default: false))
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
    
    func updateUserData(customerId:String = "7290794967219"){
        let user = CustomerUpdateRequest(customer: CustomerUpdateRequestBody(first_name: firstNameTextFieldData, last_name: secondNameTextFieldData, phone: phoneTextFieldData, email: emailTextFieldData))
        Network.shared.updateData(object: user, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers/\(customerId).json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response.customer?.email)
                    self?.fetchUserById(id: customerId)
                    
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
    
    func fetchCompletedOrders(customerId: String) {
        let url = "\(Support.baseUrl)/orders.json?customer_id=\(customerId)"
        
        Network.shared.request(url, method: "GET", responseType: OrderResponse.self) { [weak self] result in
            switch result {
            case .success(let orderResponse):
                DispatchQueue.main.async {
                    self?.orderList = orderResponse.orders ?? []
                    print("completed orders are ",orderResponse.orders?.count)
                }
            case .failure(let error):
                print("Error fetching orders: \(error)")
            }
        }
    }

    
}
