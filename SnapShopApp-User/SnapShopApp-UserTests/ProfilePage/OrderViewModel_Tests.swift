//
//  OrderViewModel_Tests.swift
//  SnapShopApp-UserTests
//
//  Created by Mostfa Sobaih on 19/06/2024.
//

import XCTest
@testable import SnapShopApp_User

class OrdersViewModelTests: XCTestCase {
    
    var viewModel: OrdersViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        clearUserDefaults()
        setUpMockData()
        viewModel = OrdersViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        clearUserDefaults()
        try super.tearDownWithError()
    }
    
    func clearUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Support.userID)
    }

    func setUpMockData() {
        UserDefaultsManager.shared.setUserId(key: Support.userID, value: 7294848041139)
    }

    func testFetchCompletedOrders() throws {
        let expectation = XCTestExpectation(description: "Fetch completed orders")
        viewModel.fetchCompletedOrders()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            XCTAssertFalse(self.viewModel.orderList.isEmpty, "Order list should not be empty after fetching completed orders")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}


