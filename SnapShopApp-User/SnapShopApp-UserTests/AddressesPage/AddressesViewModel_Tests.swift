//
//  AddressesViewModel.swift
//  SnapShopApp-UserTests
//
//  Created by Mostfa Sobaih on 20/06/2024.
//

import Foundation
import XCTest
@testable import SnapShopApp_User

final class AddressesViewModel_Tests: XCTestCase {
    
    var viewModel: AddressesViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = AddressesViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    
    func testFetchUserAddresses() {
        let expectation = self.expectation(description: "Fetch user addresses")
        
        viewModel.fetchUserAddresses()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotNil(self.viewModel.addresses, "Addresses should not be nil after fetching")
            XCTAssertFalse(self.viewModel.addresses!.isEmpty, "Addresses should contain data after fetching")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPostUserAddress() {
        let expectation = self.expectation(description: "Post user address")
        let newAddress = NewAddressRoot(customer_address: NewAddressDetails(id: nil, customer_id: UserDefaultsManager.shared.getUserId(key: Support.userID), address1: "Mohamed ali", address2: nil, city: "Portsaid", zip: "44944", phone: "+201285340337", name: nil, province_code: nil, country_code: "EG", country_name: "Egypt", default: false))
        
        viewModel.postUserAddress(address: newAddress)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let containsNewAddress = self.viewModel.addresses?.contains(where: { $0.address1 == newAddress.customer_address?.address1 })
            XCTAssertTrue(containsNewAddress ?? false, "Addresses should contain the newly added address")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testDeleteUserAddress() {
         let expectation = self.expectation(description: "Delete user address")
         
         viewModel.fetchUserAddresses()
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
             guard let addressToDelete = self.viewModel.addresses?.first else {
                 XCTFail("No address available to delete")
                 return
             }
             
             self.viewModel.deleteAddress(addressId: addressToDelete.id!)
             
             DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                 let containsDeletedAddress = self.viewModel.addresses?.contains(where: { $0.id == addressToDelete.id })
                 XCTAssertFalse(containsDeletedAddress ?? true, "Addresses should not contain the deleted address")
                 expectation.fulfill()
             }
         }
         
         waitForExpectations(timeout: 20, handler: nil)
     }
    func testUpdateUserAddress() {
            let expectation = self.expectation(description: "Update user address")
            
            viewModel.fetchUserAddresses()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                guard let addressToUpdate = self.viewModel.addresses?.first else {
                    XCTFail("No address available to update")
                    return
                }
                
                let updatedAddress = AddressForUpdate(customer_address: AddressProfileDetails(id: addressToUpdate.id, customer_id: addressToUpdate.customer_id, first_name: "Updated", last_name: addressToUpdate.last_name, company: addressToUpdate.company, address1: addressToUpdate.address1, address2: addressToUpdate.address2, city: addressToUpdate.city, province: addressToUpdate.province, country: addressToUpdate.country, zip: addressToUpdate.zip, phone: addressToUpdate.phone, name: "Updated Name", province_code: addressToUpdate.province_code, country_code: addressToUpdate.country_code, country_name: addressToUpdate.country_name, default: addressToUpdate.default))
                
                self.viewModel.updateAddress(updatedAddress: updatedAddress, addressId: addressToUpdate.id!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    let updated = self.viewModel.addresses?.contains(where: { $0.name == "Updated Name" && $0.id == addressToUpdate.id })
                    XCTAssertTrue(updated ?? false, "Addresses should contain the updated address")
                    expectation.fulfill()
                }
            }
            
            waitForExpectations(timeout: 20, handler: nil)
        }
    
    
    
    
}
