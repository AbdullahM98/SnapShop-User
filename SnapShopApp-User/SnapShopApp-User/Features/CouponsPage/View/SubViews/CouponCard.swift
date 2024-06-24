//
//  CouponCard.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import SwiftUI

struct CouponCard: View {
    var imageName:String
    var discountCode:String
    var discountValue:String
    var discountTitle:String
    var fromCart: Bool
    var onSelectCoupon: ()->Void
    var body: some View {
            ZStack(alignment: .center) {
                Image(imageName)
                    .resizable()
                    .cornerRadius(5)
                    .frame(width: UIScreen.main.bounds.width-20, height: UIScreen.main.bounds.height/4)
                    .scaledToFit()
                    .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                VStack(alignment: .leading) {
                    Text("\(discountValue)%")
                        .font(Font.system(size: 40)).fontWeight(.heavy)
                        .fontWidth(.expanded).fontDesign(.rounded)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading).padding(.leading,10)
                    Text(" \(discountTitle).")
                        .foregroundColor(.white)
                        .font(Font.system(size: 24)).fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading).padding(.leading,20)
                    Spacer()
                    Text("with code : \(discountCode)")
                        .font(Font.system(size: 20))
                        .foregroundColor(Color(UIColor.white))
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .leading).padding(.leading,30)
                    Spacer()
                    if fromCart {
                        Text("Redeem Now") .padding(10)
                            .background(Color.white)
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .padding(.leading,10)
                            .onTapGesture {
                                print("pressing....")
                                onSelectCoupon()
                            }
                    }
                }
                .padding()
            }.frame(height: 200)
            .padding(.vertical,16)
    }
}
