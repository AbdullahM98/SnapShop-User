//
//  UserDefaultsManager_Tests.swift
//  SnapShopApp-UserTests
//
//  Created by Mostfa Sobaih on 19/06/2024.
//

import XCTest
@testable import SnapShopApp_User

class UserDefaultsManagerTests: XCTestCase {

    let userDefaultsManager = UserDefaultsManager.shared
    
    override func setUpWithError() throws {
        clearUserDefaults()
    }

    override func tearDownWithError() throws {
        clearUserDefaults()
    }

    func clearUserDefaults() {
        let keys = ["isLoggedInKey", "userIdKey", "hasDraftOrdersKey", "draftOrderIdKey", "selectedCurrency", "currencyValue", "couponCode", "priceRuleId"]
        keys.forEach { UserDefaults.standard.removeObject(forKey: $0) }
    }

    func testSetAndGetIsLoggedIn() {
        let key = "isLoggedInKey"
        userDefaultsManager.setIsloggedIn(key: key, value: true)
        XCTAssertEqual(userDefaultsManager.getIsloggedIn(key: key), true, "Expected isLoggedIn to be true")
        
        userDefaultsManager.setIsloggedIn(key: key, value: false)
        XCTAssertEqual(userDefaultsManager.getIsloggedIn(key: key), false, "Expected isLoggedIn to be false")
    }
    
    func testSetAndGetUserId() {
        let key = "userIdKey"
        userDefaultsManager.setUserId(key: key, value: 123)
        XCTAssertEqual(userDefaultsManager.getUserId(key: key), 123, "Expected userId to be 123")
        
        userDefaultsManager.setUserId(key: key, value: 456)
        XCTAssertEqual(userDefaultsManager.getUserId(key: key), 456, "Expected userId to be 456")
    }
    
    func testSetAndGetUserHasDraftOrders() {
        let key = "hasDraftOrdersKey"
        userDefaultsManager.hasDraft = true
        XCTAssertEqual(userDefaultsManager.hasDraft , true, "Expected hasDraftOrders to be true")
        
    }
    
    func testSetAndGetUserDraftOrderId() {
        let key = "draftOrderIdKey"
        userDefaultsManager.userDraftId =  101112
        XCTAssertEqual(userDefaultsManager.userDraftId ,101112, "Expected draftOrderId to be 101112")
    }

    func testSelectedCurrencyCode() {
        userDefaultsManager.selectedCurrencyCode = "USD"
        XCTAssertEqual(userDefaultsManager.selectedCurrencyCode, "USD", "Expected selectedCurrencyCode to be 'USD'")
        
        userDefaultsManager.selectedCurrencyCode = "EUR"
        XCTAssertEqual(userDefaultsManager.selectedCurrencyCode, "EUR", "Expected selectedCurrencyCode to be 'EUR'")
    }

    func testSelectedCurrencyValue() {
        userDefaultsManager.selectedCurrencyValue = "1.0"
        XCTAssertEqual(userDefaultsManager.selectedCurrencyValue, "1.0", "Expected selectedCurrencyValue to be '1.0'")
        
        userDefaultsManager.selectedCurrencyValue = "0.85"
        XCTAssertEqual(userDefaultsManager.selectedCurrencyValue, "0.85", "Expected selectedCurrencyValue to be '0.85'")
    }

    func testSelectedCouponCodeValue() {
        userDefaultsManager.selectedCouponCodeValue = "SAVE10"
        XCTAssertEqual(userDefaultsManager.selectedCouponCodeValue, "SAVE10", "Expected selectedCouponCodeValue to be 'SAVE10'")
        
        userDefaultsManager.selectedCouponCodeValue = "DISCOUNT20"
        XCTAssertEqual(userDefaultsManager.selectedCouponCodeValue, "DISCOUNT20", "Expected selectedCouponCodeValue to be 'DISCOUNT20'")
    }

    func testPriceRuleIdForCoupon() {
        userDefaultsManager.priceRuleIdForCoupon = 1001
        XCTAssertEqual(userDefaultsManager.priceRuleIdForCoupon, 1001, "Expected priceRuleIdForCoupon to be 1001")
        
        userDefaultsManager.priceRuleIdForCoupon = 2002
        XCTAssertEqual(userDefaultsManager.priceRuleIdForCoupon, 2002, "Expected priceRuleIdForCoupon to be 2002")
    }
}
