//
//  HomeView.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel : HomeViewModel

    var body: some View {
        CustomAppBar()
        CarouselSlider()
        ScrollView{
            PopularBrands(viewModel: viewModel)
            BestSeller(viewModel: viewModel)
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
