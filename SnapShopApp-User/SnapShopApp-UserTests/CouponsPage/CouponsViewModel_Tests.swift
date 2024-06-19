//
//  CouponsViewModel.swift
//  SnapShopApp-UserTests
//
//  Created by Mostfa Sobaih on 19/06/2024.
//

import Foundation
import XCTest
@testable import SnapShopApp_User

final class CouponsViewModel_Tests: XCTestCase {
    var viewModel: CouponsViewModel!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = CouponsViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
    }

    func testFetchingPriceRules() throws {
        let expectation = XCTestExpectation(description: "Fetch price rules")
        viewModel.fetchPriceRules()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Assert that price rules are fetched correctly
//            XCTAssertNotNil(self.viewModel.priceRules)
            XCTAssertTrue(self.viewModel.priceRules.count == 2)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

    }

    func testFetchCoupons() throws {
        let expectation = XCTestExpectation(description: "Fetch price rules")
        viewModel.fetchCoupons()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Assert that price rules are fetched correctly
            XCTAssertNotNil(self.viewModel.coupones)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)

    }

}
