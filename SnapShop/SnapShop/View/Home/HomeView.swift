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
        CarouselSlider(adsImages: ["1","2"])
        ScrollView{
            PopularBrands()
            BestSeller()
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
