//
//  CouponsPage.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct CouponsPage: View {
    @StateObject var viewModel = CouponsViewModel()
    var couponsBG: [String] = ["Coupon1", "Coupon2", "Coupon3", "Coupon4"]
    var fromCart: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            if viewModel.isLoading{
                Spacer()
                
                LottieView(animationFileName: "ShoppingAnimation", loopMode: .loop)
                    .frame(width: 200, height: 200)
                    .navigationTitle("Coupons")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: CustomBackButton())
                Spacer()
            }else{
                VStack(spacing: 20) {
                    ScrollView {
                        ForEach(viewModel.coupones, id: \.id) { coupon in
                            if let rule = viewModel.dict[coupon] {
                                CouponCard(
                                    imageName: couponsBG.randomElement() ?? "Coupon1",
                                    discountCode: coupon.code ?? "",
                                    discountValue: String(rule.value?.dropFirst().dropLast(2) ?? ""),
                                    discountTitle: rule.title ?? "", fromCart: fromCart) {
                                        UserDefaultsManager.shared.selectedCouponCodeValue = coupon.code ?? ""
                                        UserDefaultsManager.shared.priceRuleIdForCoupon = rule.id 
                                        presentationMode.wrappedValue.dismiss() // Dismiss the second view
                                        
                                    }
                            }
                        }
                    }
                }
                .navigationTitle("Coupons")
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: CustomBackButton())
            }
        }
        .onAppear{
            viewModel.fetchPriceRules()
        }
        
    }
}

struct CouponsPage_Previews: PreviewProvider {
    static var previews: some View {
        CouponsPage(fromCart: false)
    }
}
