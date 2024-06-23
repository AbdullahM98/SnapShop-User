//
//  MockFirebaseManager.swift
//  SnapShopApp-UserTests
//
//  Created by Abdullah Essam on 23/06/2024.
//

import Foundation

@testable import SnapShopApp_User
class MockFirebaseManager: AuthenticationProtocol {

    
    
    var shouldSucceed = true
    
    func registerUser(email: String, password: String, completionHandler: @escaping (Bool, String?, Error?) -> Void) {
        if shouldSucceed {
            completionHandler(true, "mockUserId", nil)
        } else {
            let error = NSError(domain: "MockErrorDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock registration error"])
            completionHandler(false, nil, error)
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        if shouldSucceed {
            completion(true, nil)
        } else {
            let error = NSError(domain: "MockErrorDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock login error"])
            completion(false, error)
        }
    }
    
    func logout() {
    
    }
    

    
    func signOutWithGoogle(completion: @escaping (Bool, Error?) -> Void) {
        if shouldSucceed {
            completion(true, nil)
        } else {
            let error = NSError(domain: "MockErrorDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Mock sign out with Google error"])
            completion(false, error)
        }
    }
}
