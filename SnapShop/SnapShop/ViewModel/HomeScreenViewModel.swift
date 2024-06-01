//
//  HomeScreenViewModel.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import Foundation
import Combine


class HomeScreenViewModel :ObservableObject{
    @Published var smartCollections: [SmartCollectionsItem] = []

    init(){
        fetchData()
    }
    
    func fetchData() {
        Network.shared.request("smart_collections", method: "GET", responseType: BrandsResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.smartCollections = response.smart_collections ?? []
            case .failure(let error):
                print("Error fetching data: \(error)")
            }
        }
    }
}
