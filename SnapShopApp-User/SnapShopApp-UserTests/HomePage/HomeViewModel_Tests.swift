//
//  HomeViewModel_Tests.swift
//  SnapShopApp-UserTests
//
//  Created by Mostfa Sobaih on 19/06/2024.
//

import XCTest
@testable import SnapShopApp_User

class HomeViewModelTests: XCTestCase {

    var viewModel: HomeViewModel!

    override func setUpWithError() throws {
        viewModel = HomeViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testFetchBrands() throws {
        let expectation = XCTestExpectation(description: "Fetch brands")
        viewModel.fetchBrands()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.smartCollections.isEmpty, "Fetched brands should not be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchProducts() throws {
        let expectation = XCTestExpectation(description: "Fetch products")
        viewModel.fetchProducts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.isLoading == false, "Fetched products should not be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }

    func testFetchProductsInCollectionSingle() throws {
        let expectation = XCTestExpectation(description: "Fetch products in single collection")
        let collectionID = "308903739571"
        viewModel.fetchProductsInCollectionSingle(collectionID: collectionID)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertFalse(self.viewModel.singleCategoryProducts.isEmpty, "Fetched products should not be empty")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5.0)
    }
}
