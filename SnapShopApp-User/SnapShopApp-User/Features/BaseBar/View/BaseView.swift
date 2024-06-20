//
//  BaseView.swift
//  SnapShopApp-User
//
//  Created by husayn on 18/06/2024.
//

import SwiftUI

struct BaseView: View {
    @StateObject var baseData = BaseViewModel()
    @StateObject private var networkMonitor = NetworkMonitor()
    
    @State var notifyCount: Int = 0
    //hiding tab bar ...
    
    init(){
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        NavigationStack{
            TabView(selection: $baseData.currentTab) {
                HomeView()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .tag(Tab.Home)
                CategoryView()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .tag(Tab.Explore)
                FavoriteView()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .tag(Tab.Favorites)
                ProfileView()
                    .frame(maxWidth: .infinity,maxHeight: .infinity)
                    .tag(Tab.Profile)
                
            }.onAppear{
                print("OnAppear")
                notifyCount = UserDefaultsManager.shared.notifyCart ?? 0
                print("Number of notification",notifyCount)
            }.onChange(of: networkMonitor.isConnected) { isConnected in
                SnackBarHelper.showSnackBar(isConnected: isConnected)
            }
            .overlay(
                //Custom Tab Bar..
                HStack(spacing: 0){
                    //tabButtons..
                    //home tab
                    TabButton(Tab: .Home)
                    //explore tabs
                    TabButton(Tab: .Explore)
                        .offset(x: -10)
                    //center curverd cart button
                    //for badge and cart navigation
                    NavigationLink(destination: CartList()) {
                        Image("cart")
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 26, height: 26)
                            .foregroundColor(.white)
                            .offset(x: -1)
                            .padding(18)
                            .background(Color.black)
                            .clipShape(Circle())
                            .shadow(color: Color.black.opacity(0.04), radius: 5, x: 5, y: 5)
                            .shadow(color: Color.black.opacity(0.04), radius: 5, x: -5, y: -5)
                        // Badge view
                        //for badge if exist
                        if notifyCount > 0 {
                            Text("\(notifyCount)")
                                .foregroundColor(.white)
                                .font(Font.system(size: 12).bold())
                                .padding(EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6))
                                .background(Color.red)
                                .clipShape(Circle())
                                .frame(width: 18,height: 18)
                                .offset(x: -18, y: -22) // Adjust badge position as needed
                        }
                    }
                    .offset(x: notifyCount > 0 ? 12 : 0,y: -28)
                    //fav tab..
                    TabButton(Tab: .Favorites)
                        .offset(x: 10)
                    //profile tab
                    TabButton(Tab: .Profile)
                }
                    .background(Color.black
                        .clipShape(CustomCuverShape())
                                //shadow
                        .shadow(color: Color.black.opacity(0.04), radius: 5,x: -5,y: -5)
                        .ignoresSafeArea(.container,edges: .bottom))
                , alignment: .bottom
            )
        }
        .navigationBarBackButtonHidden(true).ignoresSafeArea(edges: .bottom)
        
    }
    @ViewBuilder
    func TabButton(Tab: Tab) ->some View{
        Button{
            withAnimation {
                baseData.currentTab = Tab
            }
        } label: {
            Image(baseData.currentTab == Tab ? Tab.rawValue + ".fill" : Tab.rawValue)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 25,height: 25)
                .foregroundColor(baseData.currentTab == Tab ? .black : .gray.opacity(0.5))
                .frame(maxWidth: .infinity)
        }
    }
}

struct BaseView_Previews: PreviewProvider {
    static var previews: some View {
        BaseView()
    }
}
