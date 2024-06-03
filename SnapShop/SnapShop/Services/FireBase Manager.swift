//
//  FireBase Manager.swift
//  SnapShop
//
//  Created by Abdullah Essam on 02/06/2024.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    
    static let shared = FirebaseManager()
 
    
    private init(){}
    
    func registerUser(email:String, password:String , compeltionHandler:@escaping (Bool,String?,Error?)->Void){
        var userId = ""
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                 if let error = error {
                     print("Error creating user: \(error.localizedDescription)")
                     compeltionHandler(false,nil, error)
                 } else {
                     print("User registered successfully")
                     
                     if let user = Auth.auth().currentUser {
                         let uid = user.uid
                       userId = uid
                     }
                     compeltionHandler(true,userId, nil)
                 }
             }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("Error signing in: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Logged in successfully")
                completion(true, nil)
            }
        }
    }
    func logout() {
           try? Auth.auth().signOut()
           print("Logged out successfully")
           // Handle post-logout logic here, such as navigating back to the login view
       }
}
