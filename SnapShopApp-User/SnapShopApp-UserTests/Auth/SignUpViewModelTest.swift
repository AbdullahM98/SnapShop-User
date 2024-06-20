//
//  SignUpViewModelTest.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 20/06/2024.
//

import XCTest
import Combine
@testable import SnapShopApp_User
final class SignUpViewModelTest: XCTestCase {
    var viewModel: SignUpViewModel!
     var cancellables: Set<AnyCancellable>!
    var network:MockNetworkService!
    override func setUpWithError() throws {
        viewModel = SignUpViewModel()
        cancellables = []
        network = MockNetworkService()
    }

    override func tearDownWithError() throws {
                viewModel = nil
               cancellables = nil
                network = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
   

       
       func testRegisterSuccess() {
           // Mck Firebase and Network responses
           
           let customer = Customer(phone: "+201023233815", password: "", last_name: "", addresses: [], email: "tesst@exxample.com", first_name: "")
           
           let expectation = self.expectation(description: "Register success")
           
           viewModel.register(customer: customer)
           
           viewModel.$isLoggedIn
               .sink { isLoggedIn in
                   if isLoggedIn {
                       XCTAssertTrue(isLoggedIn)
                       XCTAssertEqual(self.viewModel.signUpResponse?.customer.email, "test@example.com")
                       expectation.fulfill()
                   }
               }
               .store(in: &cancellables)
           
           waitForExpectations(timeout: 8, handler: nil)
       }

       func testRegisterFailure() {
           // Mock Firebase response with failure
          
           
           let customer = Customer(phone: "+201023888487", password: "", last_name: "", addresses: [], email: "test@example.com", first_name: "")
           
           let expectation = self.expectation(description: "Register failure")
           
           viewModel.register(customer: customer)
           
           DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               XCTAssertFalse(self.viewModel.isLoggedIn)
               expectation.fulfill()
           }
           
           waitForExpectations(timeout: 5, handler: nil)
       }
       
       func testSaveUserId() {
           let mockResponse = authResponse(customer: CustomerAuthResponse(id: 21, email: ""))
           viewModel.saveUserId(signUpResponse: mockResponse)
           
           let savedUserId = UserDefaultsManager.shared.getUserId(key: Support.userID)
           XCTAssertEqual(savedUserId, 21)
           
           let isLoggedIn = UserDefaultsManager.shared.getIsloggedIn(key: Support.isLoggedUDKey)
           XCTAssertTrue(isLoggedIn ?? false)
       }
       

}
