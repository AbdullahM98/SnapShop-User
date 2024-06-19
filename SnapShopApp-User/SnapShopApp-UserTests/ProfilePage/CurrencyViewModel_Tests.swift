//
//  CurrencyViewModel_Tests.swift
//  SnapShopApp-UserTests
//
//  Created by Mostfa Sobaih on 19/06/2024.
//

import XCTest
@testable import SnapShopApp_User

class CurrencyViewModelTests: XCTestCase {

    var viewModel: CurrencyViewModel!

    override func setUpWithError() throws {
        viewModel = CurrencyViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testInitialState() throws {
        XCTAssertNil(viewModel.currenciesList, "Initial currenciesList should be nil")
        XCTAssertEqual(viewModel.searchText, "", "Initial searchText should be empty")
    }

    func testFetchingCurrenciesSuccess() throws {
        let expectation = XCTestExpectation(description: "Fetch currencies successfully")
        viewModel.fetchingCurrencies()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Wait a bit longer for network response
            XCTAssertNotNil(self.viewModel.currenciesList, "Currencies list should not be nil after fetching")
            XCTAssertFalse(self.viewModel.currenciesList?.conversion_rates.isEmpty ?? true, "Currencies list should have items")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testFilteredCurrencies() throws {
        let expectation = XCTestExpectation(description: "Fetch and filter currencies")
        viewModel.fetchingCurrencies()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertNotNil(self.viewModel.currenciesList, "Currencies list should not be nil after fetching")
            self.viewModel.searchText = "USD"
            XCTAssertTrue(self.viewModel.filteredCurrencies.contains(where: { $0.0 == "USD" }), "Filtered currencies should contain USD")
            self.viewModel.searchText = "Euro"
            XCTAssertTrue(self.viewModel.filteredCurrencies.contains(where: { $0.0 == "EUR" }), "Filtered currencies should contain EUR for 'Euro'")
            self.viewModel.searchText = "NonExistentCurrency"
            XCTAssertTrue(self.viewModel.filteredCurrencies.isEmpty, "Filtered currencies should be empty for unmatched search text")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
