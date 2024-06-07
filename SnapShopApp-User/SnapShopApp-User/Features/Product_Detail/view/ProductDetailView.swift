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
    @StateObject var viewModel = ProductDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
              //  Color.white
                VStack() {
                    
//                    CarouselSlider(adsImages: ["1","2"]).padding(.bottom,4).ignoresSafeArea(edges: .top)
//                        .frame(height: UIScreen.screenHeight * 0.4).background(Color.gray)
                    AsyncImage(url: URL(string: viewModel.imgUrl ?? "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.3)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.3)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.3)
                        @unknown default:
                            EmptyView()
                                .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight * 0.3)
                        }
                    }
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    
                        
                    VStack(alignment: .leading) {
                        HStack {
                            Text($viewModel.vendorTitle.wrappedValue).foregroundColor(.gray).font(.subheadline)
                            HStack() {
                        
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.yellow)
                            
                                Text("(4.5)").font(.subheadline).foregroundStyle(Color.black)
                                Spacer()
                                Image(systemName: "heart").resizable().frame(width: 30,height: 28)
                            }
                                .foregroundColor(.gray)
                        
                        }.padding(.top,-5)
                        HStack {
                            Text($viewModel.productTitle.wrappedValue)
                                .font(.title3).fontWeight(Font.Weight.medium).multilineTextAlignment(/*@START_MENU_TOKEN@*/.leading/*@END_MENU_TOKEN@*/)
                          
                        }
                        HStack(){
                            Text("\($viewModel.currentCurrency.wrappedValue) \($viewModel.price.wrappedValue)").font(.headline.bold()).foregroundStyle(Color.red)
                            Spacer()
                            Text("Qty:\($viewModel.availbleQuantity.wrappedValue)").foregroundStyle(Color.gray)
                            
                        }.padding(.top,-5)
                        Text("Description")
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.top, 15)
                        
                        Text($viewModel.productDecription.wrappedValue).multilineTextAlignment(.leading).font(.subheadline).padding(.top,3)
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("Size")
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                
                                HStack {
                                    ForEach(["S", "M", "L"], id: \.self) { size in
                                        Button {
                                            print("Select item")
                                        } label: {
                                            Text(size)
                                                .foregroundColor(Color.black)
                                        }
                                        .frame(width: 24, height: 24)
                                        .background(Color.clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color.black, lineWidth: 2)
                                        )
                                    }
                                }
                            }.frame(maxWidth: .infinity, alignment: .leading)
                            
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Colors")
                                    .font(.system(size: 18))
                                    .fontWeight(.semibold)
                                
                                   HStack {
                                       ForEach([Color.red, Color.blue, Color.orange, Color.green], id: \.self) { color in
                                           CustomColorDot(color: color, isSelected: color == viewModel.selectedColor)
                                               .onTapGesture {
                                                   viewModel.selectedColor = color
                                               }
                                       }
                                   }
                            }
                            .frame(maxWidth: .infinity)
                        }.padding(.top,10)
                        
                        
                        AppButton(text: "Add to Cart", width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.06, isFilled: true){
                            guard let product = $viewModel.product.wrappedValue else{return}
                            print("here is the product \(product)")
                        }.padding(.top,30)
                    }
                    .padding()
                    .background(Color.white)
            
                    .offset(y: -30)
                }
            }.onAppear{
                viewModel.fetchProductByID(productID)
            }
        }
    }
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

#Preview {
    ProductDetailView(productID: "")
}