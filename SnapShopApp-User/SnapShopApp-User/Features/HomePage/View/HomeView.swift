//
//  HomeView.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        VStack{
            if viewModel.isLoading {
                Spacer()
                CustomCircularProgress()
                Spacer()
            }else{
                CustomAppBar()
                CarouselSlider()
                ScrollView{
                    PopularBrands(viewModel: viewModel)
                    BestSeller(viewModel: viewModel)
                }
            }
        }.padding(.bottom,60).onAppear{
            viewModel.fetchBrands()
            viewModel.fetchProducts()
            if UserDefaultsManager.shared.hasDraft == false {
                viewModel.fetchAllDraftOrdersOfApplication()
                viewModel.getUserDraftOrders()
            }
            
        }
        
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
