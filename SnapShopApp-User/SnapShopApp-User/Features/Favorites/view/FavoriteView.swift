//
//  FavoriteView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 11/06/2024.
//

import SwiftUI

struct FavoriteView: View {
    @StateObject var viewModel = FavoriteViewModel(firestoreService: FirestoreManager(), coreDBService: AppCoreData.shared)

    
    var body: some View {
        
        
        if $viewModel.viewState.wrappedValue == .userActive {
            
            VStack{
                
                Text("Favorites").padding(.vertical,30).font(.title3)
                ScrollView{
                    ForEach(viewModel.products , id: \.product_id){ product in
                        FavItemView(product: product, onDeleteClick: {  _ in
                            viewModel.removeFromFavLocal(product: product)
                            if let index = viewModel.products.firstIndex(where: { $0.product_id == product.product_id }) {
                                
                                viewModel.products.remove(at: index)
                            }
                        })
                    }
                    
                }
            }.padding(.bottom,60)
                .onAppear{
                    viewModel.getUserFav()
                }
            
            
            
        }else if $viewModel.viewState.wrappedValue == .loading {
            VStack {
                Spacer()
                
                LottieView(animationFileName: "ShoppingAnimation", loopMode: .loop)
                    .frame(width: 200, height: 200)
                Spacer()
            }
            
        }else{
            // show no fav image
            VStack(alignment:.center){
                Image("empty_box").resizable().padding(.vertical,150)
            }
        }
        
        
        
        
        
    }
    
    
    struct FavItemView : View {
        var onDeleteClick:  (_ product:ProductEntity) -> Void
        var product : ProductEntity?
        @State private var showingDeleteAlert = false
        @AppStorage("isDarkMode") private var isDarkMode = false
        
        init(product: ProductEntity , onDeleteClick: @escaping ( _ product:ProductEntity) -> Void) {
            self.product = product
            self.onDeleteClick = onDeleteClick
        }
        var body : some View{
            VStack{
                NavigationLink(destination: ProductDetailView(productID: product?.product_id?.description ?? " ")) {
                    HStack{
                        AsyncImage(url: URL(string: product?.images![0] ?? "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png")) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenHeight * 0.2)
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 64,height: 64)
                                    .cornerRadius(10)
                                    .aspectRatio(contentMode: .fit)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .frame(width: 64,height: 64)
                                    .cornerRadius(10)
                                    .aspectRatio(contentMode: .fit)
                            @unknown default:
                                EmptyView()
                                    .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenHeight * 0.2)
                            }
                        }
                        VStack(alignment: .leading,spacing: 2){
                            Text(product?.title ?? "")
                                .lineLimit(1)
                                .foregroundColor(isDarkMode ? Color.white : Color.black)
                            Text(product?.vendor ?? "").foregroundColor(Color.gray)
                            Text("\(String(format: "%.2f",(Double(product?.price ?? "0") ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                                .bold()
                                .foregroundColor(isDarkMode ? Color.white : Color.black)
                        }
                        VStack(alignment: .trailing,spacing: 20){
                            Button {
                                print("delete item")
                                showingDeleteAlert = true
                                
                            } label: {
                                Image("trash")
                                
                                
                            }.alert(isPresented: $showingDeleteAlert) {
                                Alert(
                                    title: Text("Remove Confirmation"),
                                    message: Text("Are you sure to remove this item?"),
                                    primaryButton: .destructive(Text("Remove"), action: {
                                        onDeleteClick(product!)
                                        showingDeleteAlert = false
                                    }),
                                    secondaryButton: .cancel(Text("Cancel"), action: {
                                        showingDeleteAlert = false
                                    })
                                )
                                
                            }
                        }
                    }
                }.padding(.all,8).background(isDarkMode ? Color.black : Color.white).cornerRadius(10).shadow(radius: 5)
            }.padding(.all,8)
            
        }
     
    }

}
