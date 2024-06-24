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
    var firestoreService : FirestoreService?
    var coreDBService : CoreDbService?
    @Published var viewState : FavViewState = .loading
    var isConnected:Bool = false
    
    // MARK: - Initializer

    init(firestoreService : FirestoreService ,  coreDBService : CoreDbService){
        self.firestoreService = FirestoreManager()
        self.coreDBService = AppCoreData.shared
        self.isConnected = UserDefaults.standard.bool(forKey: Support.isConnected)
       print("Fav init")
        if UserDefaults.standard.bool(forKey: Support.isLoggedUDKey) {
            print(" signed in ")
            viewState = .userActive
        }else{
            print("not signed in ")

            viewState = .userInActive
        }
    }
  
    // MARK: - Public Methods

    func getUserFav(){
        // online or offline
        
        
        self.products = getAllLocalFav(userId:UserDefaults.standard.integer(forKey: Support.userID).description)
        if self.products.count == 0  {
            print(" >>>>>>>>>> == 0\(self.products.count)")
            self.viewState = .userInActive
        }else{      
            print(" >>>>>>>>>> != 0\(self.products.count)")

            self.viewState = .userActive
        }
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
               firestoreService?.getAllFavProductsRemote(userId: userId)
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
                           if products.count != 0 {
                               print(">>>>>>>> count is \(products.count)")
                               self?.products = products
                               self?.viewState = .userActive
                           }else{
                               self?.viewState = .userInActive
                           }
                           
                       }
                   })
                   .store(in: &cancellables)
           }else{
              print("NotLoggedIn")
           }
       }
       
    func addProductToFavorites(product: ProductEntity) {
        if viewState == .userActive{
            firestoreService?.addProductToFavRemote(product: product)
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
           firestoreService?.removeProductFromFavRemote(productId: productId)
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
    
    func getAllLocalFav(userId:String) ->[ProductEntity]{
        print("Getting all favs")
       // let  = UserDefaults.standard.integer(forKey: Support.userID).description
        return  coreDBService?.getAllProducts(by: userId) ?? []
    }
    func addLocalFavProduct(product:ProductEntity){
        coreDBService?.addFavProduct(favProduct: product)
    }
    func removeFromFavLocal(product:ProductEntity){
        coreDBService?.deleteProduct(product: product)
    }
}

enum FavViewState {
    case userInActive
    case userActive
    case loading
}
