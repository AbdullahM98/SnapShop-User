//
//  AddressesViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 10/06/2024.
//

import Foundation

class AddressesViewModel:ObservableObject{
    @Published var addresses: [AddressProfileDetails]?
    @Published var isLoading = false
    init(){
        print("AddressesViewModel INIT")
        fetchUserAddresses()
    }
    deinit{
        print("DEINIT Addresses viewModel")
    }
    //get user address to UserAddresses page
    func fetchUserAddresses(customerId:String = "7290794967219"){
        let url = "\(Support.baseUrl)/customers/\(customerId)/addresses.json"
        Network.shared.request(url, method: "GET", responseType: AddressProfileRoot.self) { [weak self] result in
            switch result {
            case .success(let address):
                DispatchQueue.main.async {
                    self?.addresses = address.addresses     
                    self?.isLoading = false

                }
            case .failure(let error):
                print("Error fetching user details: \(error)")
            }
        }
        
    }
    //post address
    func postUserAddress(address: NewAddressRoot){
        Network.shared.postData(object: address, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers/\(address.customer_address?.customer_id ?? 0)/addresses.json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response.customer_address?.name)
                    self?.fetchUserAddresses()
                    
                }
            case .failure(let error):
                print("Error posting user address: \(error)")
            }
        }
    }
    //delete address
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
