//
//  OnBoardingView.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 20/06/2024.
//

import SwiftUI
var totalPages = 3
struct OnBoardingView: View {
    @AppStorage("currentPage") var currentPage = 1
    var body: some View {
        ZStack{
            if currentPage == 1 {
                
                ScreenView(image: "on1", title: "Updated Products Everyday", details: "Don’t worry , you won’t be outdated.")
            }
            if currentPage == 2{
                
                ScreenView(image: "on2", title: "Easy Transaction And Payment", details: "Your package will come right to your door ASAP!")
            }
            if currentPage == 3{
                
                ScreenView(image: "on3", title: "Free-Shipping Vouchers", details: "We care about your package as you do.")
            }
        }
    }
    struct ScreenView: View{
        @AppStorage("currentPage") var currentPage = 1
        var image:String
        var title:String
        var details:String
        var body: some View {
            
            VStack{
                HStack{
                    if currentPage == 1 {
                        /*
                        Text("SnapShop")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .kerning(1.4)*/
                    }else {
                        Button(action: {
                            currentPage -= 1
                        }) {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(.black)
                        }
                        
                    }
                    Spacer()
                    Button(action: {
                        currentPage = 4
                    },label: {
                        Text("Skip")
                            .fontWeight(.semibold)
                            .kerning(1.2)
                    })
                }.padding()
                    .foregroundColor(.black)
                Spacer(minLength: 0)
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.horizontal,16)
                    .frame(height: 300)
                Spacer(minLength: 80)
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .kerning(1.2)
                    .padding(.top)
                    .padding(.bottom,5)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)

                Text(details)
                    .font(.body)
                    .fontWeight(.regular)
                    .kerning(1.2)
                    .padding([.leading,.trailing])
                    .multilineTextAlignment(.center)
                Spacer(minLength: 0)
                HStack{
                    if currentPage == 1{
                        
                        Color(.black)
                            .frame(height: 8 / UIScreen.main.scale)
                        Color(.gray)
                            .frame(height: 8 / UIScreen.main.scale)
                        Color(.gray)
                            .frame(height: 8 / UIScreen.main.scale)
                    } else if currentPage == 2{
                        
                        Color(.gray)
                            .frame(height: 8 / UIScreen.main.scale)
                        Color(.black)
                            .frame(height: 8 / UIScreen.main.scale)
                        Color(.gray)
                            .frame(height: 8 / UIScreen.main.scale)
                        
                    }else if currentPage == 3{
                        
                        Color(.gray)
                            .frame(height: 8 / UIScreen.main.scale)
                        Color(.gray)
                            .frame(height: 8 / UIScreen.main.scale)
                        Color(.black)
                            .frame(height: 8 / UIScreen.main.scale)
                        
                    }
                }.padding(.horizontal,35)
                Button(action: {
                    if currentPage <= totalPages {
                        currentPage += 1
                    }else{
                        currentPage = 1
                    }
                }) {
                    if currentPage == 3 {
                        
                        Text("Get Started")
                            .fontWeight(.semibold)
                            .frame(minWidth: 0,maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(40)
                            .padding(.horizontal,16)
                    } else {
                        
                        Text("Next")
                            .fontWeight(.semibold)
                            .frame(minWidth: 0,maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(40)
                            .padding(.horizontal,16)
                    }
                }
            }
        }
        
    }
}
