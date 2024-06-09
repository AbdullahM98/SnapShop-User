//
//  CartCard.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import SwiftUI


struct CartCard: View {
    @State var qty: Int = 1
    var  order: DraftOrderItemDetails
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
        CartCard(order: DraftOrderItemDetails(id: nil, note: nil, email: nil, taxes_included: nil, currency: nil, invoice_sent_at: nil, created_at: nil, updated_at: nil, tax_exempt: nil, completed_at: nil, name: nil, status: nil, line_items: nil, shipping_address: nil, billing_address: nil, invoice_url: nil, applied_discount: nil, order_id: nil, shipping_line: nil, tax_lines: nil, tags: nil, note_attributes: nil, total_price: nil, subtotal_price: nil, total_tax: nil, payment_terms: nil, presentment_currency: nil, total_line_items_price_set: nil, total_price_set: nil, subtotal_price_set: nil, total_tax_set: nil, total_discounts_set: nil, total_shipping_price_set: nil, total_additional_fees_set: nil, total_duties_set: nil, admin_graphql_api_id: nil, customer: nil, use_customer_default_address: nil))
    }
}
