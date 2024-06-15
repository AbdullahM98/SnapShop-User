//
//  OrderResponse.swift
//  SnapShopApp-User
//
//  Created by Mostfa Sobaih on 10/06/2024.
//

import Foundation

// Response for the list of orders
struct OrderResponse: Codable {
    let orders: [Order]?
}
struct PostOrderResponse: Codable {
    let orders: Order?
}

// Individual Order model
struct Order: Codable, Identifiable {
    let id: Int?
    let admin_graphql_api_id: String?
    let app_id: Int?
    let browser_ip: String?
    let buyer_accepts_marketing: Bool?
    let cancel_reason: String?
    let cancelled_at: String?
    let cart_token: String?
    let checkout_id: Int?
    let checkout_token: String?
    let client_details: OrderClientDetails?
    let closed_at: String?
    let company: String?
    let confirmation_number: String?
    let confirmed: Bool?
    let contact_email: String?
    let created_at: String?
    let currency: String?
    let current_subtotal_price: String?
    let current_subtotal_price_set: OrderPriceSet?
    let current_total_additional_fees_set: OrderPriceSet?
    let current_total_discounts: String?
    let current_total_discounts_set: OrderPriceSet?
    let current_total_duties_set: OrderPriceSet?
    let current_total_price: String?
    let current_total_price_set: OrderPriceSet?
    let current_total_tax: String?
    let current_total_tax_set: OrderPriceSet?
    let customer_locale: String?
    let device_id: String?
    let discount_codes: [OrderDiscountCode]?
    let email: String?
    let estimated_taxes: Bool?
    let financial_status: String?
    let fulfillment_status: String?
    let landing_site: String?
    let landing_site_ref: String?
    let location_id: String?
    let merchant_of_record_app_id: String?
    let name: String?
    let note: String?
    let note_attributes: [OrderNoteAttribute]?
    let number: Int?
    let order_number: Int?
    let order_status_url: String?
    let original_total_additional_fees_set: OrderPriceSet?
    let original_total_duties_set: OrderPriceSet?
    let payment_gateway_names: [String]?
    let phone: String?
    let po_number: String?
    let presentment_currency: String?
    let processed_at: String?
    let reference: String?
    let referring_site: String?
    let source_identifier: String?
    let source_name: String?
    let source_url: String?
    let subtotal_price: String?
    let subtotal_price_set: OrderPriceSet?
    let tags: String?
    let tax_exempt: Bool?
    let tax_lines: [OrderTaxLine]?
    let taxes_included: Bool?
    let test: Bool?
    let token: String?
    let total_discounts: String?
    let total_discounts_set: OrderPriceSet?
    let total_line_items_price: String?
    let total_line_items_price_set: OrderPriceSet?
    let total_outstanding: String?
    let total_price: String?
    let total_price_set: OrderPriceSet?
    let total_shipping_price_set: OrderPriceSet?
    let total_tax: String?
    let total_tax_set: OrderPriceSet?
    let total_tip_received: String?
    let total_weight: Int?
    let updated_at: String?
    let user_id: String?
    let billing_address: OrderAddress?
    let customer: OrderCustomer?
    let discount_applications: [OrderDiscountApplication]?
    let fulfillments: [OrderFulfillment]?
    let line_items: [OrderLineItem]?
    let payment_terms: OrderPaymentTerms?
    let refunds: [OrderRefund]?
    let shipping_address: OrderAddress?
    let shipping_lines: [OrderShippingLine]?
}

// Supporting models for the Order

struct OrderClientDetails: Codable {
    let accept_language: String?
    let browser_height: Int?
    let browser_ip: String?
    let browser_width: Int?
    let session_hash: String?
    let user_agent: String?
}

struct OrderPriceSet: Codable {
    let shop_money: OrderMoney?
    let presentment_money: OrderMoney?
}

struct OrderMoney: Codable {
    let amount: String?
    let currency_code: String?
}

struct OrderDiscountCode: Codable {
    let code: String?
    let amount: String?
    let type: String?
}

struct OrderNoteAttribute: Codable {
    let name: String?
    let value: String?
}

struct OrderTaxLine: Codable {
    let price: String?
    let rate: Double?
    let title: String?
    let price_set: OrderPriceSet?
}

struct OrderAddress: Codable {
    let first_name: String?
    let address1: String?
    let phone: String?
    let city: String?
    let zip: String?
    let province: String?
    let country: String?
    let last_name: String?
    let address2: String?
    let company: String?
    let latitude: Double?
    let longitude: Double?
    let name: String?
    let country_code: String?
    let province_code: String?
}

struct OrderCustomer: Codable, Identifiable {
    let id: Int?
    let email: String?
    let created_at: String?
    let updated_at: String?
    let first_name: String?
    let last_name: String?
    let state: String?
    let note: String?
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let phone: String?
    let email_marketing_consent: OrderMarketingConsent?
    let sms_marketing_consent: OrderMarketingConsent?
    let tags: String?
    let currency: String?
    let tax_exemptions: [String]?
    let admin_graphql_api_id: String?
    let default_address: OrderAddress?
}

struct OrderMarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
    let consent_collected_from: String?
}

struct OrderDiscountApplication: Codable {
    let code: String?
    let value: String?
    let type: String?
}

struct OrderFulfillment: Codable {
    let id: Int?
    let admin_graphql_api_id: String?
    let created_at: String?
    let updated_at: String?
    let status: String?
    let tracking_company: String?
    let shipment_status: String?
    let tracking_number: String?
    let tracking_numbers: [String]?
    let tracking_url: String?
    let tracking_urls: [String]?
    let receipt: OrderFulfillmentReceipt?
    let line_items: [OrderLineItem]?
}

struct OrderFulfillmentReceipt: Codable {
    let id: Int?
    let email: String?
    let text: String?
}

struct OrderLineItem: Codable, Identifiable {
    let id: Int?
    let admin_graphql_api_id: String?
    let attributed_staffs: [String]?
    let current_quantity: Int?
    let fulfillable_quantity: Int?
    let fulfillment_service: String?
    let fulfillment_status: String?
    let gift_card: Bool?
    let grams: Int?
    let name: String?
    let price: String?
    let price_set: OrderPriceSet?
    let product_exists: Bool?
    let product_id: Int?
    let properties: [DraftOrderProperties]?
    let quantity: Int?
    let requires_shipping: Bool?
    let sku: String?
    let taxable: Bool?
    let title: String?
    let total_discount: String?
    let total_discount_set: OrderPriceSet?
    let variant_id: Int?
    let variant_inventory_management: String?
    let variant_title: String?
    let vendor: String?
    let tax_lines: [OrderTaxLine]?
    let duties: [OrderDuty]?
    let discount_allocations: [OrderDiscountAllocation]?
}

struct OrderDuty: Codable {
    let country_code_of_origin: String?
    let country_name_of_origin: String?
    let harmonized_system_code: String?
    let id: Int?
    let admin_graphql_api_id: String?
    let price: String?
    let price_set: OrderPriceSet?
}

struct OrderDiscountAllocation: Codable {
    let amount: String?
    let discount_application_index: Int?
    let amount_set: OrderPriceSet?
}

struct OrderPaymentTerms: Codable {
    let due_in_days: Int?
    let payment_schedule: [OrderPaymentSchedule]?
}

struct OrderPaymentSchedule: Codable {
    let amount: String?
    let currency: String?
    let date: String?
}

struct OrderRefund: Codable {
    let id: Int?
    let admin_graphql_api_id: String?
    let created_at: String?
    let note: String?
    let user_id: Int?
    let processed_at: String?
    let restock: Bool?
    let order_id: Int?
    let refund_line_items: [OrderRefundLineItem]?
    let transactions: [OrderTransaction]?
    let receipt: OrderRefundReceipt?
}

struct OrderRefundLineItem: Codable {
    let id: Int?
    let admin_graphql_api_id: String?
    let line_item_id: Int?
    let location_id: Int?
    let quantity: Int?
    let restock_type: String?
    let subtotal: String?
    let subtotal_set: OrderPriceSet?
    let total_tax: String?
    let total_tax_set: OrderPriceSet?
}

struct OrderTransaction: Codable {
    let id: Int?
    let admin_graphql_api_id: String?
    let amount: String?
    let authorization: String?
    let created_at: String?
    let device_id: String?
    let gateway: String?
    let kind: String?
    let location_id: Int?
    let order_id: Int?
    let payment_details: OrderPaymentDetails?
    let parent_id: Int?
    let processed_at: String?
    let receipt: OrderTransactionReceipt?
}

struct OrderPaymentDetails: Codable {
    let credit_card_bin: String?
    let avs_result_code: String?
    let cvv_result_code: String?
    let credit_card_number: String?
    let credit_card_company: String?
}

struct OrderTransactionReceipt: Codable {
    let id: Int?
    let email: String?
    let text: String?
}

struct OrderRefundReceipt: Codable {
    let id: Int?
    let email: String?
    let text: String?
}

struct OrderShippingLine: Codable {
    let id: Int?
    let title: String?
    let price: String?
    let code: String?
    let source: String?
    let phone: String?
    let requested_fulfillment_service_id: Int?
    let delivery_category: String?
    let carrier_identifier: String?
    let discounted_price: String?
    let price_set: OrderPriceSet?
    let discounted_price_set: OrderPriceSet?
    let carrier_service: String?
    let tracking_company: String?
    let tracking_number: String?
    let tracking_numbers: [String]?
    let tracking_url: String?
    let tracking_urls: [String]?
}


//struct PostOrderRequest: Codable {
//    let order: PostOrderDetails
//}
//
//struct PostOrderDetails: Codable {
//    let customer_id: String
//    let line_items: [PostLineItem]
//    let total_price: String?
//    let shipping_address: PostAddress?
//    let billing_address: PostAddress?
//    let payment_method: String?
//}
//
//struct PostLineItem: Codable {
//    let product_id: String
//    let quantity: Int
//    let price: String?
//}
//
//struct PostAddress: Codable {
//    let address1: String
//    let city: String
//    let country: String
//    let zip: String
//}
//
//struct PoostOrderRequest: Codable {
//    let order: PoostOrderDetails
//}
//
//// Order details model
//struct PoostOrderDetails: Codable {
//    let customer: PoostCustomer
//    let line_items: [PoostLineItem]
//    let price: Double
//}
//
//// Customer model
//struct PoostCustomer: Codable {
//    let id: Int
//}
//
//// Line item model
//struct PoostLineItem: Codable {
//    let variant_id: Int
//    let product_id: Int
//    let title: String
//    let quantity: Int
//}
