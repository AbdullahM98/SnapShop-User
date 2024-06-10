//
//  CartCard.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI


struct CartCard: View {
    @State var qty: Int = 1
    var item: DraftOrderLineItem
    var onDeleteClick: (_ item:DraftOrderLineItem)->Void
    
    var body: some View {
        VStack{
            HStack{
                AsyncImage(url: URL(string: item.properties?.first?.value ?? "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png")) { phase in
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
                    Text(item.title ?? "")
                        .lineLimit(1)
                        .frame(width: 220)
                    Text(item.vendor ?? "").foregroundColor(Color.gray)
                    Text(item.price ?? "")
                        .bold()
                }
                VStack(alignment: .trailing,spacing: 20){
                    Button {
                        print("delete item")
                        onDeleteClick(item)
                    } label: {
                        Image("trash")
                        
                    }.padding(.trailing,8)
                    HStack{
                        Button{
                            //minus quantity
                            self.qty -= 1
                        } label: {
                            Image(systemName: "minus")
                        }.foregroundColor(qty == 1 ? .gray : .black)
                            .disabled(self.qty == 1)
                        Text("\(self.qty)")
                            .padding(.horizontal,3)
                        Button{
                            //plus quantity
                            self.qty += 1
                        } label: {
                            Image(systemName: "plus")
                        }.foregroundColor(Color.black)
                    }
                }
            }
        }.padding(.all,8)
    }
}

struct CartCard_Previews: PreviewProvider {
    static var previews: some View {
        CartCard(item: DraftOrderLineItem(id: nil, variant_id: nil, product_id: nil, title: nil, variant_title: nil, sku: nil, vendor: nil, quantity: nil, requires_shipping: nil, taxable: nil, gift_card: nil, fulfillment_service: nil, grams: nil, tax_lines: nil, applied_discount: nil, name: nil, properties: nil, custom: nil, price: nil, admin_graphql_api_id: nil), onDeleteClick: {item in })
    }
}
