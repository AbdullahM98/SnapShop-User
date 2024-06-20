//
//  ProfileViewModel_Tests.swift
//  SnapShopApp-UserTests
//
//  Created by Mostfa Sobaih on 19/06/2024.
//

import Foundation
import XCTest
@testable import SnapShopApp_User

final class ProfileViewModel_Tests: XCTestCase {
    var viewModel: ProfileViewModel!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ProfileViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testFetchingUserById() throws {
        let expectation = XCTestExpectation(description: "Fetch user data")
        viewModel.fetchUserById()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertNil(self.viewModel.user)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

    }

    
    func testUpdatingUserData() throws {
        let expectation = XCTestExpectation(description: "Update user data")

        viewModel.updateUserData(user: CustomerUpdateRequest(customer: CustomerUpdateRequestBody(first_name: "Ali", last_name: "ali", phone: "+201212129129", email: "ali@ali.com")))
          DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
              XCTAssertTrue(self.viewModel.isLoading == true, "failed to update user data")
              expectation.fulfill()
          }
          
          wait(for: [expectation], timeout: 10.0)
      }

    func testFetchUserById_Success() {
            let expectation = XCTestExpectation(description: "Fetch user by ID")
            
            // Simulate logged in state for testing purposes
            UserDefaults.standard.set(true, forKey: Support.isLoggedUDKey)
            UserDefaults.standard.set(123, forKey: Support.userID) // Replace with a valid user ID
            
            // Call the method
            viewModel.fetchUserById()
            
            // Fulfill the expectation when the network request completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // Assert expected changes in state after fetching user
                XCTAssertNil(self.viewModel.user)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 3.0)
        }
    func testFetchUserById_Failure() {
            let expectation = XCTestExpectation(description: "Fetch user by ID")
            
            // Simulate logged in state for testing purposes
            UserDefaults.standard.set(true, forKey: Support.isLoggedUDKey)
            UserDefaults.standard.set(456, forKey: Support.userID) // Replace with a non-existing user ID
            
            // Call the method
            viewModel.fetchUserById()
            
            // Fulfill the expectation when the network request completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                // Assert expected changes in state after fetching user
                XCTAssertNil(self.viewModel.user)
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 3.0)
        }

     func testLogout() {
         // Simulate logged in state for testing purposes
         UserDefaults.standard.set(true, forKey: Support.isLoggedUDKey)
         
         // Call the method
         viewModel.logout()
         
         // Assert expected changes in UserDefaults
         XCTAssertFalse(UserDefaults.standard.bool(forKey: Support.isLoggedUDKey))
     }
  

}
