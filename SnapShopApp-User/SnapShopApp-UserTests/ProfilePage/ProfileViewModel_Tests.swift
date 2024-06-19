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
            XCTAssertNotNil(self.viewModel.user)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

    }

    
    func testUpdatingUserData() throws {
        let expectation = XCTestExpectation(description: "Update user data")

        viewModel.updateUserData(user: CustomerUpdateRequest(customer: CustomerUpdateRequestBody(first_name: "Ali", last_name: "ali", phone: "+201212129129", email: "ali@ali.com")))
          DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
              XCTAssertTrue(self.viewModel.isLoading == false, "failed to update user data")
              expectation.fulfill()
          }
          
          wait(for: [expectation], timeout: 10.0)
      }

  

}
