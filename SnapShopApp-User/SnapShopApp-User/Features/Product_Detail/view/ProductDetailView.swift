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
            ZStack {
                Color.white
                VStack(alignment: .leading) {
                    
//                        Image("1")
//                            .resizable()
//                            .ignoresSafeArea(edges: .top)
//                            .frame(height: UIScreen.screenHeight * 0.4)
                        
                    VStack(alignment: .leading) {
                        HStack {
                            Text($viewModel.vendorTitle.wrappedValue).foregroundColor(.gray).font(.subheadline)
                            HStack() {
                        
//                                Image(systemName: "star.fill")
//                                    .resizable()
//                                    .frame(width: 15, height: 15)
//                                    .foregroundColor(.yellow)
                            
                                Text("(4.5)").font(.subheadline).foregroundStyle(Color.black)
                                Spacer()
//                                Image("heart").resizable().frame(width: 25,height: 25)
                            }
                                .foregroundColor(.gray)
                        
                        }.padding(.bottom,10)
                        HStack {
                            Text($viewModel.productTitle.wrappedValue)
                                .font(.title3).fontWeight(Font.Weight.medium)
                          
                        }
                        HStack(){
                            Text("\($viewModel.currentCurrency.wrappedValue) \($viewModel.price.wrappedValue)").font(.headline.bold()).foregroundStyle(Color.red)
                            Text("Qty:\($viewModel.availbleQuantity.wrappedValue)").foregroundStyle(Color.gray)
                            
                        }
                        Text("Description")
                            .font(.title3)
                            .fontWeight(.medium)
                            .padding(.vertical, 4)
                        
                        Text($viewModel.productDecription.wrappedValue).multilineTextAlignment(.leading).font(.subheadline)
                        
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
                                    // Add your ColorDotView implementation or any other color indicator
                                    ColorDotView(color: .red)
                                    ColorDotView(color: .blue)
                                    ColorDotView(color: .orange)
                                    ColorDotView(color: .green)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }.padding(.vertical)
                        
                        
                        AppButton(text: "Add to Cart", width: UIScreen.screenWidth * 0.9, height: UIScreen.screenHeight * 0.06, isFilled: true){
                            guard let product = $viewModel.product.wrappedValue else{return}
                            print("here is the product \(product)")
                        }.padding(.top,30)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .offset(y: -30)
                }
            }.onAppear{
                viewModel.fetchProductByID(productID)
            }
        }.ignoresSafeArea(edges: .top)
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
