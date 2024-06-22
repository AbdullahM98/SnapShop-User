//
//  CartCard.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI

struct CartCard: View {
    var item: DraftOrderLineItem
    var onDeleteClick: (_ item: DraftOrderLineItem) -> Void
    @State private var showingDeleteAlert = false
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(productID: item.product_id?.description ?? " ")) {
            VStack{
                HStack {
                    AsyncImage(url: URL(string: item.properties?.first?.value ?? "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenHeight * 0.2)
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 64, height: 64)
                                .cornerRadius(10)
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .cornerRadius(10)
                                .aspectRatio(contentMode: .fit)
                        @unknown default:
                            EmptyView()
                                .frame(width: UIScreen.screenWidth * 0.2, height: UIScreen.screenHeight * 0.2)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(extractedTitle(item.title ?? ""))
                            .lineLimit(1)
                            .foregroundColor(.black)
                        Text(item.vendor ?? "")
                            .foregroundColor(Color.gray)
                        
                        Text("\(String(format: "%.0f",(Double(formatPrice(price: item.price, quantity: item.quantity)) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                            .bold()
                            .foregroundColor(.black)
                            .bold()
                    }
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 20) {
                        Button {
                            showingDeleteAlert = true
                        } label: {
                                                        Image("trash")
//                            Image(systemName:"minus.circle.fill").foregroundColor(.black)
                        }.alert(isPresented: $showingDeleteAlert) {
                            Alert(
                                title: Text("Delete Confirmation"),
                                message: Text("Are you sure to delete this item?"),
                                primaryButton: .destructive(Text("Delete"), action: {
                                    onDeleteClick(item)
                                    showingDeleteAlert = false
                                }),
                                secondaryButton: .cancel(Text("Cancel"), action: {
                                    showingDeleteAlert = false
                                })
                            )
                        }
                        .padding(.trailing, 8)
                        
                        Text("Qty: \(item.quantity ?? 0)")
                            .foregroundColor(.black)
                    }.padding()
                }.padding(.all,8).background(.white).cornerRadius(10).shadow(radius: 5)

            }.padding(.all,8)
            
        }
    }
    
    func calculateTotalPrice(price: String?, quantity: Int?) -> Double {
        let priceDouble = Double(price ?? "0.0") ?? 0.0
        let quantityDouble = Double(quantity ?? 0)
        return priceDouble * quantityDouble
    }
    
    func formatPrice(price: String?, quantity: Int?) -> String {
        let totalPrice = calculateTotalPrice(price: price, quantity: quantity)
        return String(format: "%.2f", totalPrice)
    }
    private func extractedTitle(_ title: String?) -> String {
            guard let title = title else { return "Unknown Title" }
            let components = title.split(separator: "|").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            if components.count > 1 {
                return components[1]
            } else {
                return title
            }
        }
}

