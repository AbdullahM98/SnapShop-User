//
//  CartViewModel_Tests.swift
//  SnapShopApp-UserTests
//
//  Created by husayn on 19/06/2024.
//
import Foundation
import XCTest
@testable import SnapShopApp_User

final class CartViewModel_Tests: XCTestCase {
    var viewModel: CartViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CartViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    func testInitialization() {
        XCTAssertNotNil(viewModel)
        XCTAssert(viewModel.viewState == .userInActive || viewModel.viewState == .userActive)
    }
    func testGetDraftOrderByIdWithExistingDraft() {
        UserDefaultsManager.shared.hasDraft = true
        viewModel.getDraftOrderById()
        
        XCTAssertNil(viewModel.userOrder)
        XCTAssertNil(viewModel.lineItems)
    }
    func testGetDraftOrderByIdWithoutExistingDraft() {
        UserDefaultsManager.shared.hasDraft = false
        viewModel.getDraftOrderById()
        
        XCTAssertNil(viewModel.userOrder)
        XCTAssertNil(viewModel.lineItems)
        XCTAssertFalse(viewModel.isLoading)
    }
    func testFetchDraftOrder(){
        viewModel.getDraftOrderById()
        XCTAssertNil(viewModel.userOrder)
    }
    func testDeleteCardDraftOrder() {
        let viewModel = CartViewModel()
        
        // Simulate logged in state and set up initial state with real data
        UserDefaults.standard.set(true, forKey: Support.isLoggedUDKey)
        viewModel.getDraftOrderById() // Ensure userOrder and lineItems are populated
        
        let expectation = XCTestExpectation(description: "Delete draft order")
        
        // Call the method
        viewModel.deleteCardDraftOrder()
        
        // Fulfill the expectation when the network request completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Assert expected changes in state after deletion
            XCTAssertTrue(viewModel.isLoading) // isLoading should be true during deletion process
            // Check
            
            func testPostAsCompleted() {
                UserDefaultsManager.shared.hasDraft = true
                viewModel.getDraftOrderById()
                
                viewModel.postAsCompleted()
                
                XCTAssertNil(viewModel.userOrder)
                XCTAssertNil(viewModel.lineItems)
            }
            
            
            func testGetDraftOrderById() {
                let viewModel = CartViewModel()
                
                // Simulate logged in state for testing purposes
                UserDefaults.standard.set(true, forKey: Support.isLoggedUDKey)
                
                let expectation = XCTestExpectation(description: "Fetch draft order")
                
                // Call the method
                viewModel.getDraftOrderById()
                
                // Fulfill the expectation when the network request completes
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    // Assert expected changes in state after fetching
                    XCTAssertFalse(viewModel.isLoading) // isLoading should be false after fetch
                    // Check other assertions based on expected network responses
                    expectation.fulfill()
                }
                
//                wait(for: [expectation], timeout: 3.0)
            }
            
            func testDeleteLineItemFromDraftOrder() {
                let viewModel = CartViewModel()
                
                // Simulate logged in state and set up initial state with real data
                UserDefaults.standard.set(true, forKey: Support.isLoggedUDKey)
                viewModel.getDraftOrderById() // Ensure userOrder and lineItems are populated
                
                // Call delete method for a specific line item
                viewModel.deleteLineItemFromDraftOrder(lineItem: viewModel.lineItems![0])
                
                // Verify state changes
                XCTAssertTrue(viewModel.isLoading)
                // Check other assertions based on expected network responses
            }
            
            func testApplyCouponOnDraftOrder() {
                UserDefaultsManager.shared.hasDraft = true
                viewModel.getDraftOrderById()
                
                let mockCoupon = AppliedDiscount(description: nil, value_type: "fixed_amount", value: "10.0", amount: "10.0", title: "Test Coupon")
                viewModel.applyCouponOnDraftOrder(couponToApply: mockCoupon)
                
                XCTAssertEqual(viewModel.userOrder?.applied_discount?.description, nil)
            }
            
            func testFetchPriceRulesByIdForApplyingCoupons() {
                UserDefaultsManager.shared.hasDraft = true
                
                let priceRuleId = 123
                viewModel.fetchPriceRulesByIdForApplyingCoupons(id: priceRuleId)
                
            }
            
        }
    }
}
