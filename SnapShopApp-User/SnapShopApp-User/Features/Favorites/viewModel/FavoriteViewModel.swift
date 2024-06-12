//
//  FavoriteViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 11/06/2024.
//

import Foundation
import Combine

class FavoriteViewModel : ObservableObject{
    
    @Published var products: [ProductEntity] = []
       private var cancellables = Set<AnyCancellable>()
       private var firestoreService = FirestoreManager()
    @Published var viewState : FavViewState
    
    init(){
        if UserDefaults.standard.bool(forKey: Support.isLoggedUDKey) {
            viewState = .userActive
        }else{
            viewState = .userInActive
        }
    }
  
       func fetchFavProducts(userId: String) {
           firestoreService.getAllFavProducts(userId: userId)
               .receive(on: DispatchQueue.main)
               .sink(receiveCompletion: { completion in
                   switch completion {
                   case .failure(let error):
                       print("Failed to fetch products: \(error)")
                       self.viewState = .userInActive
                   case .finished:
                       break
                   }
               }, receiveValue: { [weak self] products in
                   DispatchQueue.main.async {
                       self?.products = products
                       self?.viewState = .userActive
                       print(" fetch products: \(products.count)")

                   }
               })
               .store(in: &cancellables)
       }
       
       func addProductToFavorites(product: ProductEntity) {
           firestoreService.addProductToFav(product: product)
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
                       self?.fetchFavProducts(userId: product.userId ?? "")
                   }
               })
               .store(in: &cancellables)
       }
       
       func removeProductFromFavorites(productId: Int) {
           firestoreService.removeProductFromFav(productId: productId)
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
                       if let index = self?.products.firstIndex(where: { $0.id == productId.description }) {
                           self?.products.remove(at: index)
                           print("Item removed successfully")
                       } else {
                           print("Item not found in the list")
                       }
                   }
               })
               .store(in: &cancellables)
       }
}

enum FavViewState {
    case userInActive
    case userActive
    case loading
}
