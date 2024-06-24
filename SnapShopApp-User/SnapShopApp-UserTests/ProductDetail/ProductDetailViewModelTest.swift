//
//  ProductDetailViewModelTest.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 20/06/2024.
//

import XCTest
import Combine
@testable import SnapShopApp_User

final class ProductDetailViewModelTest: XCTestCase {
    var viewModel: ProductDetailViewModel!
        var mockNetwork: MockNetworkService!
        var mockAppCoreData: MockAppCoreData!
        var mockUserDefaultsManager: MockUserDefaultsManager!
        var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
          mockNetwork = MockNetworkService()
                mockAppCoreData = MockAppCoreData()
                mockUserDefaultsManager = MockUserDefaultsManager()
                viewModel = ProductDetailViewModel()
                cancellables = []
    }

    override func tearDownWithError() throws {
             viewModel = nil
                mockNetwork = nil
                mockAppCoreData = nil
                mockUserDefaultsManager = nil
                cancellables = nil    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    
    func testFetchProductByIDSuccess() {
        let productModel = ProductModel(id: 1, title: "Test Product", body_html: "Test Description", vendor: "Test Vendor", product_type: "Test Type", tags: "Test Tag" , status: "", variants: [Variant(id: 1, product_id: 22, title: "sa", price: "322", sku: "", position: 11, inventory_item_id: 16, inventory_quantity:20, old_inventory_quantity: 20, image_id: 21)], options: nil , images: [] ,image: product_Image(id: 2, alt: "", position: 1, product_id: 3, width: 43, height: 32, src: "", variant_ids: []))
        let productResponse = ProductResponse(product: productModel)
        mockNetwork.getItemByIDResult = Just(productResponse)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        
        let expectation = self.expectation(description: "Fetch product by ID")
        
        viewModel.fetchProductByID("1")
        
        viewModel.$product
            .sink { product in
                XCTAssertNotEqual(product?.product_id, "1")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchProductByIDFailure() {
        mockNetwork.getItemByIDResult = Fail(error: URLError(.badServerResponse))
            .eraseToAnyPublisher()
        
        let expectation = self.expectation(description: "Fetch product by ID failure")
        
        viewModel.fetchProductByID("1")
        
        viewModel.$product
            .sink { product in
                XCTAssertNil(product)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAddLocalFavProduct() {
        let product = ProductEntity(userId: "20", product_id: "21", variant_Id: "22", title: "aa", body_html: "des", vendor: "ss", product_type: "sa", inventory_quantity: "21", tags: "", price: "222", images: [""])
        mockAppCoreData.isProductInFavoritesReturnValue = false
        
        viewModel.addLocalFavProduct(product: product)
        
        XCTAssertFalse(mockAppCoreData.products.contains(where: { $0.product_id == "21" }))
    }
    
    func testRemoveFromFavLocal() {
        let product = ProductEntity(userId: "20", product_id: "21", variant_Id: "22", title: "aa", body_html: "des", vendor: "ss", product_type: "sa", inventory_quantity: "21", tags: "", price: "222", images: [""])
        mockAppCoreData.products = [product]
        
        viewModel.removeFromFavLocal(product: product)
        
        XCTAssertTrue(mockAppCoreData.products.contains(where: { $0.product_id == "21" }))
    }
    
    func testPrepareDraftOrderToPost() {
        let productModel = ProductModel(id: 1, title: "Test Product", body_html: "Test Description", vendor: "Test Vendor", product_type: "Test Type", tags: "Test Tag" , status: "", variants: [Variant(id: 1, product_id: 22, title: "sa", price: "322", sku: "", position: 11, inventory_item_id: 16, inventory_quantity:20, old_inventory_quantity: 20, image_id: 21)], options: nil , images: [] ,image: product_Image(id: 2, alt: "", position: 1, product_id: 3, width: 43, height: 32, src: "", variant_ids: []))
        viewModel.productModel = productModel
        mockUserDefaultsManager.getUserIdResult = 1
        mockUserDefaultsManager.hasDraft = false
        
        viewModel.prepareDraftOrderToPost()
        
        XCTAssertNil(viewModel.orderToPost)
    }
    
    func testPrepareDraftOrderToPostWithExistingDraft() {
        let productModel = ProductModel(id: 1, title: "Test Product", body_html: "Test Description", vendor: "Test Vendor", product_type: "Test Type", tags: "Test Tag" , status: "", variants: [Variant(id: 1, product_id: 22, title: "sa", price: "322", sku: "", position: 11, inventory_item_id: 16, inventory_quantity:20, old_inventory_quantity: 20, image_id: 21)], options: nil , images: [] ,image: product_Image(id: 2, alt: "", position: 1, product_id: 3, width: 43, height: 32, src: "", variant_ids: []))
        viewModel.productModel = productModel
        mockUserDefaultsManager.getUserIdResult = 1
        mockUserDefaultsManager.hasDraft = true
        mockUserDefaultsManager.userDraftId = 1
        
        let expectation = self.expectation(description: "Prepare draft order to post with existing draft")
        
        viewModel.prepareDraftOrderToPost()
        
        viewModel.$orderToUpdate
            .sink { order in
                XCTAssertNil(order)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
