//
//  FavoriteViewModelTest.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 20/06/2024.
//

import XCTest
import Combine
@testable import SnapShopApp_User
final class FavoriteViewModelTest: XCTestCase {
    
    var viewModel: FavoriteViewModel!
    var mockFirestoreManager: MockFirestoreManager!
    var mockAppCoreData: MockAppCoreData!
    var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        mockFirestoreManager = MockFirestoreManager()
                mockAppCoreData = MockAppCoreData()
                viewModel = FavoriteViewModel()
                viewModel.firestoreService = mockFirestoreManager
               // AppCoreData.shared = mockAppCoreData
                cancellables = []
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockFirestoreManager = nil
        mockAppCoreData = nil
        cancellables = nil
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

}
