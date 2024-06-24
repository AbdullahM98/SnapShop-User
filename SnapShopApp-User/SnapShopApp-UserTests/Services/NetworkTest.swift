//
//  NetworkTest.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 20/06/2024.
//

import XCTest
import Combine
@testable import SnapShopApp_User

final class NetworkTest: XCTestCase {
    var networkService: Network!
       var cancellables: Set<AnyCancellable>!
    
    override func setUpWithError() throws {
        networkService = Network.shared
        cancellables = []
    }

    override func tearDownWithError() throws {
        networkService = nil
        cancellables = nil
    }
    
    
    func testRequest() {
        let expectation = self.expectation(description: "Request expectation")
        
        networkService.request("https://jsonplaceholder.typicode.com/posts/1", method: "GET", responseType: Post.self) { result in
            switch result {
            case .success(let post):
                XCTAssertEqual(post.id, 1)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Request failed with error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPostData() {
        let expectation = self.expectation(description: "Post data expectation")
        
        let post = Post(userId: 1, id: 101, title: "foo", body: "bar")
        
        networkService.postData(object: post, to: "https://jsonplaceholder.typicode.com/posts") { result in
            switch result {
            case .success(let returnedPost):
                XCTAssertEqual(returnedPost.title, "foo")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Post data failed with error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testUpdateData() {
        let expectation = self.expectation(description: "Update data expectation")
        
        let post = Post(userId: 1, id: 1, title: "foo", body: "bar")
        
        networkService.updateData(object: post, to: "https://jsonplaceholder.typicode.com/posts/1") { result in
            switch result {
            case .success(let updatedPost):
                XCTAssertEqual(updatedPost.title, "foo")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Update data failed with error: \(error.localizedDescription)")
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testDeleteObject() {
        let expectation = self.expectation(description: "Delete object expectation")
        
        networkService.deleteObject(with: "https://jsonplaceholder.typicode.com/posts/1") { error in
            XCTAssertNil(error, "Delete object failed with error: \(String(describing: error?.localizedDescription))")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPostCustomer() {
        let customer = Customer(phone: "+2010092919291", password: "211212121", last_name: "anything", addresses: [Address(phone: "+2010092919291", country: "Eg", address1: "anything", first_name: "Crew", last_name: "anything", city: "Cairo")], email: "Crew@eg.com", first_name: "Crew")
        
        let expectation = self.expectation(description: "Post customer expectation")
        
        networkService.postCustomer(customer)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Post customer request failed with error: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }, receiveValue: { response in
                XCTAssertNotNil(response.customer)
                XCTAssertEqual(response.customer.email, "Done")
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testGetItemByID() {
        let expectation = self.expectation(description: "Get item by ID expectation")
        
        networkService.getItemByID("7882324082867", type: Post.self, endpoint: "posts")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Get item by ID request failed with error: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }, receiveValue: { post in
                XCTAssertEqual(post.id, 1)
            })
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
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
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
