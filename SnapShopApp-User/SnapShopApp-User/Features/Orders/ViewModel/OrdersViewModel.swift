//
//  OrdersViewModel.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import Foundation

class OrdersViewModel :ObservableObject{
    @Published var orderList : [Order] = []
    
    init() {
        print("OrderVM INIT")
    }
    deinit {
        print("OrderVM DEINIT")
    }

    func fetchCompletedOrders(customerId: String) {
        let url = "\(Support.baseUrl)/orders.json?customer_id=\(customerId)"
        
        Network.shared.request(url, method: "GET", responseType: OrderResponse.self) { [weak self] result in
            switch result {
            case .success(let orderResponse):
                DispatchQueue.main.async {
                    self?.orderList = orderResponse.orders ?? []
                    print("completed orders are ",orderResponse.orders?.count)
                }
            case .failure(let error):
                print("Error fetching orders: \(error)")
            }
        }
    }

    // Define a function to post an order using the provided postData method
    func postOrder() {
        let lineItems = [
            OrderLineItem(id: nil, admin_graphql_api_id: nil, attributed_staffs: nil, current_quantity: nil, fulfillable_quantity: nil, fulfillment_service: nil, fulfillment_status: nil, gift_card: nil, grams: nil, name: nil, price: nil, price_set: nil, product_exists: nil, product_id: 7882327785651, properties: nil, quantity: 1, requires_shipping: nil, sku: nil, taxable: nil, title: "ADIDAS | CLASSIC BACKPACK | LEGEND INK MULTICOLOUR", total_discount: nil, total_discount_set: nil, variant_id: 43637106933939, variant_inventory_management: nil, variant_title: nil, vendor: nil, tax_lines: nil, duties: nil, discount_allocations: nil),
            OrderLineItem(id: nil, admin_graphql_api_id: nil, attributed_staffs: nil, current_quantity: nil, fulfillable_quantity: nil, fulfillment_service: nil, fulfillment_status: nil, gift_card: nil, grams: nil, name: nil, price: nil, price_set: nil, product_exists: nil, product_id: 7882327785651, properties: nil, quantity: 1, requires_shipping: nil, sku: nil, taxable: nil, title: "ADIDAS | CLASSIC BACKPACK | LEGEND INK MULTICOLOUR", total_discount: nil, total_discount_set: nil, variant_id: 43637106933939, variant_inventory_management: nil, variant_title: nil, vendor: nil, tax_lines: nil, duties: nil, discount_allocations: nil)
           
        ]
//
//        // Create a sample customer
//        let customer = PoostCustomer(id: 7290794967219)
//
//        // Create the order details
//        let orderDetails = PoostOrderDetails(customer: customer, line_items: lineItems, price: 3000.00)
//
//        // Create the order request
//        let orderRequest = OrderResponse(order: orderDetails)
//
        // URL for posting the order
        let url = "\(Support.baseUrl)/orders.json"
        
        let orderRequest = PostOrderResponse(orders: Order(id: nil, admin_graphql_api_id: nil, app_id: nil, browser_ip: nil, buyer_accepts_marketing: nil, cancel_reason: nil, cancelled_at: nil, cart_token: nil, checkout_id: nil, checkout_token: nil, client_details: nil, closed_at: nil, company: nil, confirmation_number: nil, confirmed: nil, contact_email: nil, created_at: nil, currency: nil, current_subtotal_price: nil, current_subtotal_price_set: nil, current_total_additional_fees_set: nil, current_total_discounts: nil, current_total_discounts_set: nil, current_total_duties_set: nil, current_total_price: nil, current_total_price_set: nil, current_total_tax: nil, current_total_tax_set: nil, customer_locale: nil, device_id: nil, discount_codes: nil, email: nil, estimated_taxes: nil, financial_status: nil, fulfillment_status: nil, landing_site: nil, landing_site_ref: nil, location_id: nil, merchant_of_record_app_id: nil, name: nil, note: nil, note_attributes: nil, number: nil, order_number: nil, order_status_url: nil, original_total_additional_fees_set: nil, original_total_duties_set: nil, payment_gateway_names: nil, phone: nil, po_number: nil, presentment_currency: nil, processed_at: nil, reference: nil, referring_site: nil, source_identifier: nil, source_name: nil, source_url: nil, subtotal_price: nil, subtotal_price_set: nil, tags: nil, tax_exempt: nil, tax_lines: nil, taxes_included: nil, test: nil, token: nil, total_discounts: nil, total_discounts_set: nil, total_line_items_price: nil, total_line_items_price_set: nil, total_outstanding: nil, total_price: nil, total_price_set: nil, total_shipping_price_set: nil, total_tax: nil, total_tax_set: nil, total_tip_received: nil, total_weight: nil, updated_at: nil, user_id: nil, billing_address: nil, customer: OrderCustomer(id: 7290794967219, email: nil, created_at: nil, updated_at: nil, first_name: nil, last_name: nil, state: nil, note: nil, verified_email: nil, multipass_identifier: nil, tax_exempt: nil, phone: nil, email_marketing_consent: nil, sms_marketing_consent: nil, tags: nil, currency: nil, tax_exemptions: nil, admin_graphql_api_id: nil, default_address: nil), discount_applications: nil, fulfillments: nil, line_items: lineItems, payment_terms: nil, refunds: nil, shipping_address: nil, shipping_lines: nil))
        
        // Use the postData method to send the order request
        Network.shared.postData(object: orderRequest, to: url) { (result: Result<PostOrderResponse, Error>) in
            switch result {
            case .success(let response):
                print("Order posted successfully: \(response)")
            case .failure(let error):
                print("Error posting order: \(error)")
            }
        }
    }
}
