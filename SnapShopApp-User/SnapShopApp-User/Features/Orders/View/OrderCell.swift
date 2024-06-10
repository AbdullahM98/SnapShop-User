//
//  OrderCell.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import SwiftUI

struct OrderCell: View {
    @State var orderDetails : Order
    var body: some View {
        VStack(alignment:.leading,spacing: 16){
            HStack{
                Text("Order No: ")
                    .foregroundColor(.gray)
                Text("\(orderDetails.name ?? "")")
            }.padding(.top,20)
                .padding(.horizontal,16)
            HStack{
                Text("No of items: ")
                    .foregroundColor(.gray)
                Text("\(orderDetails.line_items?.count ?? 0)")
            }.padding(.top,20)
                .padding(.horizontal,16)
            HStack{
                Text("Address: ")
                    .foregroundColor(.gray)
                Text("\(orderDetails.shipping_address?.address1 ?? ""),\(orderDetails.shipping_address?.city ?? "")")
            }.padding(.vertical,4)
                .padding(.horizontal,16)
            HStack{
                Text("Money Paid: ")
                    .foregroundColor(.gray)
                Text("\(orderDetails.current_total_price ?? "")")
                Spacer()
            }.padding(.vertical,4)
                .padding(.horizontal,16)
            HStack{
                Text("Date: ")
                    .foregroundColor(.gray)
                Text("\(orderDetails.created_at ?? "")")
            }.padding(.vertical,4)
                .padding(.horizontal,16)
                .padding(.bottom,20)
        }.border(Color.gray,width: 1)
            .padding(16)
            
    }
}

struct OrderCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderCell(orderDetails: Order(id: 0, admin_graphql_api_id: nil, app_id: nil, browser_ip: nil, buyer_accepts_marketing: nil, cancel_reason: nil, cancelled_at: nil, cart_token: nil, checkout_id: nil, checkout_token: nil, client_details: nil, closed_at: nil, company: nil, confirmation_number: nil, confirmed: nil, contact_email: nil, created_at: nil, currency: nil, current_subtotal_price: nil, current_subtotal_price_set: nil, current_total_additional_fees_set: nil, current_total_discounts: nil, current_total_discounts_set: nil, current_total_duties_set: nil, current_total_price: nil, current_total_price_set: nil, current_total_tax: nil, current_total_tax_set: nil, customer_locale: nil, device_id: nil, discount_codes: nil, email: nil, estimated_taxes: nil, financial_status: nil, fulfillment_status: nil, landing_site: nil, landing_site_ref: nil, location_id: nil, merchant_of_record_app_id: nil, name: nil, note: nil, note_attributes: nil, number: nil, order_number: nil, order_status_url: nil, original_total_additional_fees_set: nil, original_total_duties_set: nil, payment_gateway_names: nil, phone: nil, po_number: nil, presentment_currency: nil, processed_at: nil, reference: nil, referring_site: nil, source_identifier: nil, source_name: nil, source_url: nil, subtotal_price: nil, subtotal_price_set: nil, tags: nil, tax_exempt: nil, tax_lines: nil, taxes_included: nil, test: nil, token: nil, total_discounts: nil, total_discounts_set: nil, total_line_items_price: nil, total_line_items_price_set: nil, total_outstanding: nil, total_price: nil, total_price_set: nil, total_shipping_price_set: nil, total_tax: nil, total_tax_set: nil, total_tip_received: nil, total_weight: nil, updated_at: nil, user_id: nil, billing_address: nil, customer: nil, discount_applications: nil, fulfillments: nil, line_items: nil, payment_terms: nil, refunds: nil, shipping_address: nil, shipping_lines: nil))
    }
}
