//
//  FirebaseManager.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - FirebaseManager Class

class FirebaseManager {
    
    // MARK: - Singleton Instance
    
    static let shared = FirebaseManager()
    
    // MARK: - Initializer
    
    private init() {
        // You can initialize any properties or setup needed here
    }
    
    // MARK: - User Authentication Methods
    
    func registerUser(email: String, password: String, completionHandler: @escaping (Bool, String?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completionHandler(false, nil, error)
            } else {
                var userId = ""
                if let user = Auth.auth().currentUser {
                    let uid = user.uid
                    userId = uid
                    UserDefaults.standard.set(uid, forKey: Support.fireBaseUserID)
                }
                completionHandler(true, userId, nil)
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false, error)
            } else {
                if let user = Auth.auth().currentUser {
                    let uid = user.uid
                    UserDefaults.standard.set(uid, forKey: Support.fireBaseUserID)
                }
                completion(true, nil)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            // Optionally, handle any post-logout logic here, such as navigating back to the login view
        } catch let error {
            // Handle the error if needed, potentially logging it or showing an alert
            print("Error logging out: \(error.localizedDescription)")
        }
    }
}
