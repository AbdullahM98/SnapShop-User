//
//  CouponsPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct CouponsPage: View {
    @ObservedObject var viewModel = CouponsViewModel()
    var couponsBG:[String] = ["Coupon1","Coupon2","Coupon3","Coupon4"]
    var body: some View {
        VStack(spacing: 20){
            ScrollView{
                
                ForEach(viewModel.coupones, id: \.id) { coupon in
                    let rule: PriceRule? = viewModel.dict[coupon]
                    CouponCard(imageName: couponsBG.randomElement() ?? "5",discountCode: coupon.code ?? "",discountValue: String(rule?.value?.dropFirst().dropLast(2) ?? ""),discountTitle: rule?.title ?? "")
                        .navigationBarTitle("Coupons")
                        .navigationBarBackButtonHidden()
                }
            }
        }
        .navigationBarItems(leading: CustomBackButton())
        .onAppear{
            viewModel.fetchPriceRules()
        }
    }
}

struct CouponsPage_Previews: PreviewProvider {
    static var previews: some View {
        CouponsPage()
    }
}
