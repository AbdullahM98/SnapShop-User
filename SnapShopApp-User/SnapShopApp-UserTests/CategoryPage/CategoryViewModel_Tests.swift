//
//  CategoryViewModel_Tests.swift
//  SnapShopApp-UserTests
//
//  Created by Mostfa Sobaih on 19/06/2024.
//

import XCTest
@testable import SnapShopApp_User

class CategoryViewModel_Tests: XCTestCase {

    var viewModel: CategoryViewModel!

    override func setUpWithError() throws {
        viewModel = CategoryViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
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

    func testFetchProductsInCollection() throws {
        let expectation = XCTestExpectation(description: "Fetch products in collection")

        let collectionID = "308903739571"
        viewModel.fetchProductsInCollection(collectionID: collectionID) {
            DispatchQueue.main.async {
                XCTAssertFalse(self.viewModel.collectionProducts.isEmpty, "Fetched products for collection should not be empty")
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5.0)
    }

}
