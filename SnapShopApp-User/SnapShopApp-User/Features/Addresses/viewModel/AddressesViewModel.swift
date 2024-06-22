//
//  AddressesViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 10/06/2024.
//

import Foundation

// MARK: - AddressesViewModel

class AddressesViewModel:ObservableObject{
    
    // MARK: - Published Properties

    @Published var addresses: [AddressProfileDetails]?
    @Published var isLoading = false
    @Published var orderToUpdate:DraftOrderItemDetails?
    
    // MARK: - Properties

    var userId: String = String(UserDefaultsManager.shared.getUserId(key: Support.userID) ?? 0)
    
    // MARK: - Fetch Methods

    //get user address to UserAddresses page
    func fetchUserAddresses(){
        let url = "\(Support.baseUrl)/customers/\(userId)/addresses.json"
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
    
    // MARK: - Post Methods

    //post address
    func postUserAddress(address: NewAddressRoot){
        Network.shared.postData(object: address, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers/\(userId)/addresses.json" ){  [weak self] result in
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
    
    // MARK: - Delete Methods

    //delete user address
    func deleteAddress(addressId:Int){
        Network.shared.deleteObject(with: "\(Support.baseUrl)/customers/\(userId)/addresses/\(addressId).json") { [weak self] result in
//            self?.fetchUserAddresses()
            switch result{
            default:
                DispatchQueue.main.async{
                    self?.addresses?.removeAll(where: {
                        item in
                        item.id == addressId
                    })
                }
            }
            print(result?.localizedDescription)
        }
    }
    
    // MARK: - Update Methods

    //update user address
    func updateAddress(updatedAddress:AddressForUpdate,addressId:Int){
        Network.shared.updateData(object: updatedAddress, to: "\(Support.baseUrl)/customers/\(userId)/addresses/\(addressId).json") { [weak self] result in
            switch result{
            case .success(let response):
                DispatchQueue.main.async {
                    print("\(response.customer_address?.country_name ?? "")")
                    self?.fetchUserAddresses()
                }
            case .failure(let err):
                print("error updating user address: \(err)")
            }
        }
    }
    
    // MARK: - Draft Order Methods

    func getDraftOrderById(){
        guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
        print("User Have DraftOrder and its ID3 is : \(orderID)")
        Network.shared.request("https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID).json", method: "GET", responseType: DraftOrderItem.self) { [weak self] result in
            switch result{
            case .success(let order):
                DispatchQueue.main.async {
                    guard let draftOrder = order.draft_order else {return}
                    self?.orderToUpdate = draftOrder
                    
                }
            case .failure(let err):
                print("Error get the user order : \(err)")
                
                
            }
        }
    }
    
    // MARK: - Address Selection Methods
    
    func selectShippingAddress(shippingAddress: AddressProfileDetails)->DraftOrderAddress{
        let newShippingAddress = DraftOrderAddress(first_name: shippingAddress.first_name ?? "", address1: shippingAddress.address1 ?? "", phone: shippingAddress.phone ?? "", city: shippingAddress.city ?? "", zip: shippingAddress.city ?? "", province: shippingAddress.province ?? "", country: shippingAddress.country ?? "", last_name: shippingAddress.last_name ?? "", address2: shippingAddress.address2 ?? "", company: shippingAddress.company ?? "", latitude: nil, longitude: nil, name: shippingAddress.name ?? "", country_code: shippingAddress.country, province_code: shippingAddress.province_code ?? "")
        
        return newShippingAddress
    }
    
    
    func updateUserShippingAddress(shippingAddress: AddressProfileDetails){
        print(" before updated shipping address \(String(describing: self.orderToUpdate?.shipping_address))")
        print(shippingAddress ,"Thats coming from para")
        self.orderToUpdate?.shipping_address = selectShippingAddress(shippingAddress: shippingAddress)
        self.orderToUpdate?.billing_address = selectShippingAddress(shippingAddress: shippingAddress)
        print(" after updated shipping address \(String(describing: self.orderToUpdate?.shipping_address))")
        
        guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
        let updatedOrder = DraftOrderItem(draft_order: self.orderToUpdate)
        Network.shared.updateData(object: updatedOrder, to: "\(Support.baseUrl)/draft_orders/\(orderID).json" ){result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Draft Shipping Address Updated Successfully")
                    print("User have ",response.draft_order?.line_items?.count ?? 0," line items")
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("Error updating user shipping address FromAddressViewModel: \(error)")
            }
        }
    }
}
