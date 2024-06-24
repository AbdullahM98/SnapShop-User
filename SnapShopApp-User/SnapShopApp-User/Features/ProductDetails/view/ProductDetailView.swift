//
//  ProductDetailView.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 06/06/2024.
//



import SwiftUI
import Combine

struct ProductDetailView: View {
    var productID: String
    var selectedQuantity = 1
    @StateObject var viewModel = ProductDetailViewModel()
    @State private var showingDeleteAlert = false
    @State private var showingOutOfStockAlert = false
    @AppStorage("isDarkMode") private var isDarkMode = false

    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            }else{
                ScrollView{
                    if let images = $viewModel.images.wrappedValue{
                        if !(viewModel.images?.isEmpty ?? false) {
                            TabView {
                                ForEach(viewModel.images!, id: \.self) { imageUrl in
                                    if let url = URL(string: imageUrl) {
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.3)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .padding()
                                    } else {
                                        Color.gray
                                            .frame(width: UIScreen.screenWidth * 0.6, height: UIScreen.screenHeight * 0.36)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .padding()
                                    }
                                }
                            }.tabViewStyle(PageTabViewStyle())
                            
                                .frame(width: UIScreen.screenWidth , height: UIScreen.screenHeight * 0.36)
                        } else {
                            Color.gray
                                .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight * 0.35)
                                .padding()
                        }
                    }
                    VStack(alignment: .leading) {
                        HStack {
                            Text($viewModel.vendorTitle.wrappedValue).foregroundColor(.gray).font(.subheadline)
                            HStack() {
                                
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.yellow)
                                
                                Text("(4.5)").font(.subheadline).foregroundStyle(isDarkMode ? Color.white : Color.black)
                                Spacer()
                                Button{
                                    if UserDefaults.standard.bool(forKey: Support.isLoggedUDKey){
                                        if $viewModel.isFavorite.wrappedValue {
                                            
                                            viewModel.isFavorite = false
                                            viewModel.removeFromFavLocal(product: (viewModel.product)!)
                                            SnackBarHelper.showSnackBar(message: "Removed ...", color: Color.red.opacity(0.8))
                                            
                                        }else{
                                            viewModel.isFavorite = true
                                            print("hhhh \(viewModel.product?.product_id ?? "22")")
                                            viewModel.addLocalFavProduct(product: viewModel.product!)
                                            
                                            SnackBarHelper.showSnackBar(message: "Inserted ..", color: Color.green)
                                        }
                                    }else{
                                        showingDeleteAlert = true
                                    }
                                }label: {
                                    Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart").resizable().frame(width: 30,height: 28)
                                    
                                }.alert(isPresented: $showingDeleteAlert) {
                                    Alert(title: Text("Guest Mode"),
                                          message: Text("Please Login for more features"),dismissButton: .destructive(Text("OK"), action: {
                                        showingDeleteAlert = false
                                    })
                                    )
                                    
                                }
                            }
                            .foregroundColor(.gray)
                            
                        }.padding(.top,-5)
                        HStack {
                            Text($viewModel.productTitle.wrappedValue)
                                .font(.title3).fontWeight(Font.Weight.medium).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                            
                        }
                        HStack(){
                            Text("\(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD") \(String(format: "%.2f", (Double(viewModel.price) ?? 1.0) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1)))")
                                .font(.headline.bold())
                                .foregroundStyle(Color.red)
                            
                            
                            
                            Spacer()
                            Text("Qty:\($viewModel.availbleQuantity.wrappedValue)").foregroundStyle(Color.gray)
                            
                        }.padding(.top,-5)
                        Text("Description")
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.top, 15)
                        
                        Text($viewModel.productDecription.wrappedValue).multilineTextAlignment(.leading).font(.subheadline).padding(.top,3)
                        
                        if $viewModel.hasOptions.wrappedValue {
                            HStack(alignment: .top) {
                                if viewModel.sizes!.count != 0 {
                                    VStack(alignment: .leading) {
                                        Text("Size")
                                            .font(.system(size: 18))
                                            .fontWeight(.semibold)
                                        
                                        HStack {
                                            ForEach(viewModel.sizes ?? [""], id: \.self) { size in
                                                Button {
                                                    print("Select item")
                                                    viewModel.selectedSize = size
                                                } label: {
                                                    Text(size)
                                                        .foregroundColor(isDarkMode ? Color.white : Color.black)
                                                }
                                                .frame(width: 24, height: 24)
                                                .background(Color.clear)
                                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 6)
                                                        .stroke(isDarkMode ? Color.white : Color.black, lineWidth: 2)
                                                )
                                            }
                                        }
                                    }.frame(maxWidth: .infinity, alignment: .leading)
                                }
                                
                                Spacer()
                                if viewModel.colors!.count != 0 {
                                    VStack(alignment: .leading) {
                                        Text("Colors")
                                            .font(.system(size: 18))
                                            .fontWeight(.semibold)
                                        
                                        HStack {
                                            ForEach(viewModel.colors ?? [Color.yellow], id: \.self) { color in
                                                CustomColorDot(color: color, isSelected: color == viewModel.selectedColor)
                                                    .onTapGesture {
                                                        viewModel.selectedColor = color
                                                    }
                                            }
                                        }.padding(.bottom,20)
                                        
                                    }.frame(maxWidth: .infinity)
                                }
                            }.padding(.top,10)
                        }else{
                            VStack{}.frame(height: UIScreen.screenHeight * 0.12)
                        }
                        
                        QuantitySelectorView(quantity:$viewModel.inventoryQuantity.wrappedValue , viewModel:viewModel)
                            .padding(.leading,90)
                        AppButton(text: "Add to Cart", width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.06, isFilled: true){
                            if UserDefaults.standard.bool(forKey: Support.isLoggedUDKey){
                                if Int($viewModel.availbleQuantity.wrappedValue) ?? 0 < 0 {
                                    showingOutOfStockAlert = true
                                } else {
                                    viewModel.prepareDraftOrderToPost()
                                    //SnackBarHelper.updatingSnackBar(body: "Added to cart ...")
                                    SnackBarHelper.showSnackBar(message: "Added to cart ...", color: Color.green)
                                }
                            }else{
                                showingDeleteAlert = true
                            }
                            
                        }.padding(.top,10)
                            .alert(isPresented: $showingOutOfStockAlert) {
                                Alert(title: Text("Sorry!"),
                                      message: Text("This Product Out of Stock."),dismissButton: .cancel(Text("OK"), action: {
                                    showingOutOfStockAlert = false
                                }))
                            }
                        
                        
                    }
                    .padding(.horizontal,24)
                    
                }
                .background(isDarkMode ? Color.black : Color.white)
            }
            
        }.padding(.all,20)
            .onAppear{
                viewModel.fetchProductByID(productID)
            }.navigationBarTitle("\(viewModel.vendorTitle)")
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: CustomBackButton())
    }
    
    
    // Ensure you have ColorDotView implemented somewhere in your project
    struct ColorDotView: View {
        var color: Color
        
        var body: some View {
            color
                .frame(width: 24, height: 24)
                .clipShape(Circle())
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        ProductDetailView(productID: "")
    }
}
