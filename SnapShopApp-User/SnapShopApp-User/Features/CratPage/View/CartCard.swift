//
//  CartCard.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI


struct CartCard: View {
    @State var qty: Int = 1
    var  order: DraftOrderResponse2
    @ObservedObject var viewModel:CartViewModel = CartViewModel.shared
    
    var body: some View {
        VStack{
            HStack{
                AsyncImage(url: URL(string: order.note ?? "https://cdn.dummyjson.com/products/images/beauty/Eyeshadow%20Palette%20with%20Mirror/thumbnail.png")) { phase in
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
                    Text(order.line_items?[0].title ?? "")
                        .lineLimit(1)
                        .frame(width: 220)
                    Text(order.line_items?[0].vendor ?? "").foregroundColor(Color.gray)
                    Text(order.line_items?[0].price ?? "")
                        .bold()
                }
                VStack(alignment: .trailing,spacing: 20){
                    Button {
                        print("delete item")
                        viewModel.deleteCardDraftOrder(id: order.id ?? 0)
                        
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
        CartCard(order: DraftOrderResponse2(id: 0, note: "", email: "", taxes_included: false, currency: "EGB", invoice_sent_at: "", created_at: "", updated_at: "", tax_exempt: nil, completed_at: "", name: "", status: "", line_items: nil, shipping_address: nil, billing_address: nil, invoice_url: nil, applied_discount: "", order_id: "", shipping_line: "", tax_lines: nil, tags: "", note_attributes: nil, total_price: "", subtotal_price: "", total_tax: "", payment_terms: "", admin_graphql_api_id: "", customer: nil))
    }
}
