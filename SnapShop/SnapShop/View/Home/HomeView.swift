//
//  HomeView.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 26/05/2024.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        CustomAppBar()
        HomeSearchBar()
        CarouselSlider(adsImages: ["1","2"])
        ScrollView{
            PopularBrands()
            BestSeller()
        }
    }
}

#Preview {
    HomeView()
}
