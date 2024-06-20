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
        VStack {
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
                    Text(item.title ?? "")
                        .lineLimit(1)
                        .frame(width: 220)
                    Text(item.vendor ?? "")
                        .foregroundColor(Color.gray)
                    
                    Text("\(String(format: "%.0f",(Double(formatPrice(price: item.price, quantity: item.quantity)) ?? 1 ) * (Double(UserDefaultsManager.shared.selectedCurrencyValue ?? "1") ?? 1))) \(UserDefaultsManager.shared.selectedCurrencyCode ?? "USD")")
                        .bold()
//                    Text("\(formatPrice(price: item.price, quantity: item.quantity))")
                        .bold()
                }
                
                VStack(alignment: .trailing, spacing: 20) {
                    Button {
                        showingDeleteAlert = true

                    } label: {
                        Image("trash")
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
                }
            }
        }
        .padding(.all, 8)
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
}

struct CartCard_Previews: PreviewProvider {
    static var previews: some View {
        CartCard(item: DraftOrderLineItem(id: nil, variant_id: nil, product_id: nil, title: nil, variant_title: nil, sku: nil, vendor: nil, quantity: nil, requires_shipping: nil, taxable: nil, gift_card: nil, fulfillment_service: nil, grams: nil, tax_lines: nil, applied_discount: nil, name: nil, properties: nil, custom: nil, price: nil, admin_graphql_api_id: nil), onDeleteClick: {item in })
    }
}
