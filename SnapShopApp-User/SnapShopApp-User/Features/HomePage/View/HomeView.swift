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
//                ProgressView()
                LottieView(animationFileName: "ShoppingAnimation", loopMode: .loop)
                    .frame(width: 200, height: 200)
                Spacer()
                    .navigationBarBackButtonHidden(true)
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
// checkForUserDrafts lw m3ndosh draft w kman el draftId bta3o = 0 w 3ndo user ID(logged in y3ne)
//lw msh logged in mt3mlsh fetch
//lw 3ndo draft mt3mlsh fetch
//lw 3ndo draft id mt3mlsh fetch
            if
                UserDefaultsManager.shared.hasDraft == false
                    && (UserDefaultsManager.shared.getUserId(key: Support.userID) != 0)
                    && (UserDefaultsManager.shared.userDraftId == 0)
            {
                print("Inside If In HVM")
                print("Bydkhol el if lw m3ndosh draft w m3ndosh draft id  w logged in, lazem logged in")
                print("user id \(UserDefaultsManager.shared.getUserId(key: Support.userID))")
                print("user has no draft order  \(UserDefaultsManager.shared.hasDraft) must be = false")
                print("user draft id \(UserDefaultsManager.shared.userDraftId) must be = 0")
                viewModel.fetchAllDraftOrdersOfApplication()
            }else{
                print("----inside else in HVM----")
                print("Hwa Bykhosh el else lw hwa msh logged in aw lw 3ndo draft aw lw el draft Id bt3o > 0")
                print("user id \(UserDefaultsManager.shared.getUserId(key: Support.userID)) ")
                print("user has no draft order  \(UserDefaultsManager.shared.hasDraft) ")
                print("user draft id \(UserDefaultsManager.shared.userDraftId) ")
            }
            
        }
        
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
