//
//  CouponsPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct CouponsPage: View {
    @ObservedObject var viewModel = CouponsViewModel.shared
    var couponsBG: [String] = ["Coupon1", "Coupon2", "Coupon3", "Coupon4"]
    
    var body: some View {
        VStack(spacing: 20) {
            ScrollView {
                ForEach(viewModel.coupones, id: \.id) { coupon in
                    if let rule = viewModel.dict[coupon] {
                        CouponCard(
                            imageName: couponsBG.randomElement() ?? "Coupon1",
                            discountCode: coupon.code ?? "",
                            discountValue: String(rule.value?.dropFirst().dropLast(2) ?? ""),
                            discountTitle: rule.title ?? ""
                        )
                    }
                }
            }
        }
        .navigationTitle("Coupons")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: CustomBackButton())
    }
}

struct CouponsPage_Previews: PreviewProvider {
    static var previews: some View {
        CouponsPage()
    }
}
