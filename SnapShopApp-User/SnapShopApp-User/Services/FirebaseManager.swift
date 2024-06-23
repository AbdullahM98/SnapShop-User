//
//  FirebaseManager.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 04/06/2024.
//

import Foundation
import FirebaseAuth
import FirebaseCore

import GoogleSignIn



protocol AuthenticationProtocol {
    func registerUser(email: String, password: String, completionHandler: @escaping (Bool, String?, Error?) -> Void)
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void)
    func logout()
    func signOutWithGoogle(completion: @escaping (Bool, Error?) -> Void)
}

// MARK: - FirebaseManager Class

class FirebaseManager : AuthenticationProtocol {
    
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
           
          } catch let error {
              print(error.localizedDescription)
          }
      }
    
    
    func signInWithGoogle(result: GIDSignInResult?, completion: @escaping (Bool, Error?) -> Void) {
           guard let user = result?.user, let idToken = user.idToken?.tokenString else {
               completion(false, NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing user or ID token"]))
               return
           }

           let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)

           Auth.auth().signIn(with: credential) { authResult, error in
               if let error = error {
                   completion(false, error)
                   return
               }

               guard let firebaseUser = authResult?.user else {
                   completion(false, NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing Firebase user"]))
                   return
               }

               // Optionally save the user ID to UserDefaults
               UserDefaults.standard.set(firebaseUser.uid, forKey: Support.fireBaseUserID)
               completion(true, nil)
           }
       }
    func signOutWithGoogle(completion: @escaping (Bool, Error?) -> Void) {
         do {
             try Auth.auth().signOut()
             GIDSignIn.sharedInstance.signOut()
             completion(true, nil)
         } catch {
             completion(false, error)
         }
     }

}
