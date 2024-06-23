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
        viewModel = FavoriteViewModel(firestoreService: mockFirestoreManager, coreDBService: mockAppCoreData)
        cancellables = Set<AnyCancellable>()
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
    
    func testFetchFavProducts_Success() {
           // Arrange
           mockFirestoreManager.products = [
               ProductEntity(
                   userId: "user1",
                   product_id: "prod1",
                   variant_Id: "var1",
                   title: "Product 1",
                   body_html: "Description of product 1",
                   vendor: "Vendor 1",
                   product_type: "Type 1",
                   inventory_quantity: "10",
                   tags: "Tag1, Tag2",
                   price: "100.00",
                   images: ["image1.jpg", "image2.jpg"],
                   isFav: true
               ),
               ProductEntity(
                   userId: "user2",
                   product_id: "prod2",
                   variant_Id: "var2",
                   title: "Product 2",
                   body_html: "Description of product 2",
                   vendor: "Vendor 2",
                   product_type: "Type 2",
                   inventory_quantity: "20",
                   tags: "Tag3, Tag4",
                   price: "200.00",
                   images: ["image3.jpg", "image4.jpg"],
                   isFav: false
               )
           ]

           // Act
           let expectation = XCTestExpectation(description: "Fetch favorite products")
           viewModel.$products
               .dropFirst()
               .sink { products in
                   XCTAssertEqual(products.count, 2)
                   XCTAssertEqual(products.first?.title, "Product 1")
                   expectation.fulfill()
               }
               .store(in: &cancellables)

           viewModel.fetchFavProducts()

           // Assert
           wait(for: [expectation], timeout: 5.0)
       }

  func testAddProductToFavorites_Success() {
           // Arrange
           mockFirestoreManager.addProductToFavResult = .success(())

           let product = ProductEntity(
               userId: "user1",
               product_id: "prod1",
               variant_Id: "var1",
               title: "Product 1",
               body_html: "Description of product 1",
               vendor: "Vendor 1",
               product_type: "Type 1",
               inventory_quantity: "10",
               tags: "Tag1, Tag2",
               price: "100.00",
               images: ["image1.jpg", "image2.jpg"],
               isFav: true
           )

           // Act
           let expectation = XCTestExpectation(description: "Add product to favorites")
           viewModel.$products
               .dropFirst()
               .sink { products in
                   XCTAssertEqual(products.count, 1)
                   XCTAssertEqual(products.first?.title, "Product 1")
                   expectation.fulfill()
               }
               .store(in: &cancellables)

           viewModel.addProductToFavorites(product: product)

           // Assert
           wait(for: [expectation], timeout: 2.0)
       }

       func testRemoveProductFromFavorites_Success() {
           // Arrange
           mockFirestoreManager.removeProductFromFavResult = .success(())

           let product = ProductEntity(
               userId: "user1",
               product_id: "prod1",
               variant_Id: "var1",
               title: "Product 1",
               body_html: "Description of product 1",
               vendor: "Vendor 1",
               product_type: "Type 1",
               inventory_quantity: "10",
               tags: "Tag1, Tag2",
               price: "100.00",
               images: ["image1.jpg", "image2.jpg"],
               isFav: true
           )

           viewModel.products = [product]

           // Act
           let expectation = XCTestExpectation(description: "Remove product from favorites")
           viewModel.$products
               .dropFirst()
               .sink { products in
                   XCTAssertEqual(products.count, 0)
                   expectation.fulfill()
               }
               .store(in: &cancellables)

           viewModel.removeProductFromFavorites(productId: product.product_id ?? "")

           // Assert
           wait(for: [expectation], timeout: 2.0)
       }

    func testGetAllLocalFav() {
           // Arrange
           let product = ProductEntity(
               userId: "user1",
               product_id: "prod1",
               variant_Id: "var1",
               title: "Product 1",
               body_html: "Description of product 1",
               vendor: "Vendor 1",
               product_type: "Type 1",
               inventory_quantity: "10",
               tags: "Tag1, Tag2",
               price: "100.00",
               images: ["image1.jpg", "image2.jpg"],
               isFav: true
           )
        let products = [product]
        mockAppCoreData.products = products
        print(">>>>>>> \(mockAppCoreData.products.count)")

           // Act
         

           // Assert
           XCTAssertEqual(products.count, 1)
           XCTAssertEqual(products.first?.title, "Product 1")
       }

       func testAddLocalFavProduct() {
           // Arrange
           let product = ProductEntity(
               userId: "user1",
               product_id: "prod1",
               variant_Id: "var1",
               title: "Product 1",
               body_html: "Description of product 1",
               vendor: "Vendor 1",
               product_type: "Type 1",
               inventory_quantity: "10",
               tags: "Tag1, Tag2",
               price: "100.00",
               images: ["image1.jpg", "image2.jpg"],
               isFav: true
           )

           // Act
           viewModel.addLocalFavProduct(product: product)
           let products = mockAppCoreData.products

           // Assert
           XCTAssertEqual(products.count, 1)
           XCTAssertEqual(products.first?.title, "Product 1")
       }

       func testRemoveFromFavLocal() {
           // Arrange
           let product = ProductEntity(
               userId: "user1",
               product_id: "prod1",
               variant_Id: "var1",
               title: "Product 1",
               body_html: "Description of product 1",
               vendor: "Vendor 1",
               product_type: "Type 1",
               inventory_quantity: "10",
               tags: "Tag1, Tag2",
               price: "100.00",
               images: ["image1.jpg", "image2.jpg"],
               isFav: true
           )
           mockAppCoreData.products = [product]

           // Act
           viewModel.removeFromFavLocal(product: product)
           let products = mockAppCoreData.products

           // Assert
           XCTAssertEqual(products.count, 0)
       }
   
}
