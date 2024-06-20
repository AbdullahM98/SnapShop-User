//
//  FavoriteViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 11/06/2024.
//

import Foundation
import Combine

// MARK: - FavoriteViewModel

class FavoriteViewModel : ObservableObject{
    
    // MARK: - Published Properties

    @Published var products: [ProductEntity] = []
       private var cancellables = Set<AnyCancellable>()
        var firestoreService = FirestoreManager()
    @Published var viewState : FavViewState = .userActive
    var isConnected:Bool = false
    
    // MARK: - Initializer

    init(){
        
        self.isConnected = UserDefaults.standard.bool(forKey: Support.isConnected)
       
        if UserDefaults.standard.bool(forKey: Support.isLoggedUDKey) {
            viewState = .userActive
        }else{
            viewState = .userInActive
        }
    }
  
    // MARK: - Public Methods

    func getUserFav(){
        // online or offline
        self.products = getAllLocalFav()
        //self.fetchFavProducts()
     
        
    }
    
    func saveProduct(product:ProductEntity){
        // online or offline
        self.saveProduct(product: product)
    }
    
    func deleteProduct(product:ProductEntity){
        // online or offline
        self.removeFromFavLocal(product: product)
        //self.removeProductFromFavorites(productId: id)
    }
    
       func fetchFavProducts() {
           if viewState == .userActive{
               guard  let userId = UserDefaults.standard.string(forKey: Support.userID) else{
                   return
               }
               firestoreService.getAllFavProductsRemote(userId: userId)
                   .receive(on: DispatchQueue.main)
                   .sink(receiveCompletion: { completion in
                       switch completion {
                       case .failure(let error):
                           
                           self.viewState = .userInActive
                       case .finished:
                           break
                       }
                   }, receiveValue: { [weak self] products in
                       DispatchQueue.main.async {
                           self?.products = products
                           self?.viewState = .userActive
                           
                       }
                   })
                   .store(in: &cancellables)
           }else{
              print("NotLoggedIn")
           }
       }
       
    func addProductToFavorites(product: ProductEntity) {
        if viewState == .userActive{
            firestoreService.addProductToFavRemote(product: product)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to add product: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] in
                DispatchQueue.main.async {
                    self?.fetchFavProducts()
                }
            })
            .store(in: &cancellables)
          }
       }
       
       func removeProductFromFavorites(productId: String) {
           firestoreService.removeProductFromFavRemote(productId: productId)
               .receive(on: DispatchQueue.main)
               .sink(receiveCompletion: { completion in
                   switch completion {
                   case .failure(let error):
                       print("Failed to remove product: \(error)")
                   case .finished:
                       break
                   }
               }, receiveValue: { [weak self] in
                   DispatchQueue.main.async{
                       if let index = self?.products.firstIndex(where: { $0.product_id == productId.description }) {
                           self?.products.remove(at: index)
                           print("Item removed successfully")
                       } else {
                           print("Item not found in the list")
                       }
                   }
               })
               .store(in: &cancellables)
       }
    
    func getAllLocalFav() ->[ProductEntity]{
        print("Getting all favs")
        let userId = UserDefaults.standard.integer(forKey: Support.userID).description
        return  AppCoreData.shared.getAllProducts(by: userId)
    }
    func addLocalFavProduct(product:ProductEntity){
        AppCoreData.shared.addFavProduct(favProduct: product)
    }
    func removeFromFavLocal(product:ProductEntity){
        AppCoreData.shared.deleteProduct(product: product)
    }
}

enum FavViewState {
    case userInActive
    case userActive
    case loading
}
