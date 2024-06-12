//
//  DrftOrdersModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import Foundation


//to get all draft orders
struct ListOfDraftOrders:Codable{
    let draft_orders:[DraftOrderItemDetails]?
}
//to post draft order or get draft order
struct DraftOrderItem: Codable {
    let draft_order: DraftOrderItemDetails?
}
//done
struct DraftOrderItemDetails: Codable {
    let id: Int?
    let note: String?
    let email: String?
    let taxes_included: Bool?
    let currency: String?
    let invoice_sent_at: String?
    let created_at: String?
    let updated_at: String?
    let tax_exempt: Bool?
    let completed_at: String?
    let name: String?
    let status: String?
    var line_items: [DraftOrderLineItem]?
    let shipping_address: DraftOrderAddress?
    let billing_address: DraftOrderAddress?
    let invoice_url: String?
    let applied_discount: AppliedDiscount?
    let order_id: Int?
    let shipping_line: String?
    let tax_lines: [DraftOrderTaxLine]?
    let tags: String?
    let note_attributes: [String]?
    let total_price: String?
    let subtotal_price: String?
    let total_tax: String?
    let payment_terms: String?
    let presentment_currency: String?
//    let total_line_items_price_set: DraftOrderPriceSet?
//    let total_price_set: DraftOrderPriceSet?
//    let subtotal_price_set: DraftOrderPriceSet?
//    let total_tax_set: DraftOrderPriceSet?
//    let total_discounts_set: DraftOrderPriceSet?
//    let total_shipping_price_set: DraftOrderPriceSet?
//    let total_additional_fees_set: DraftOrderPriceSet?
//    let total_duties_set: DraftOrderPriceSet?
    let admin_graphql_api_id: String?
    let customer: DraftOrderCustomer?
    let use_customer_default_address:Bool?
}
//done
struct DraftOrderLineItem: Codable {
    let id: Int?
    let variant_id: Int?
    let product_id: Int?
    let title: String?
    let variant_title: String?
    let sku: String?
    let vendor: String?
    var quantity: Int?
    let requires_shipping: Bool?
    let taxable: Bool?
    let gift_card: Bool?
    let fulfillment_service: String?
    let grams: Int?
    let tax_lines: [DraftOrderTaxLine]?
    let applied_discount: AppliedDiscount?
    let name: String?
    let properties: [DraftOrderProperties]?
    let custom: Bool?
    let price: String?
    let admin_graphql_api_id: String?
}
struct AppliedDiscount:Codable{
    let description: String?
    let value_type: String?
    let value: String?
    let amount: String?
    let title: String?
}
struct DraftOrderProperties: Codable{
    let name: String?
    let value: String?
}

struct DraftOrderAddress: Codable {
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

struct DraftOrderDiscount: Codable {
    let description: String
    let value: String
    let title: String
    let amount: String
    let value_type: String
}
//
//struct DraftOrderPriceSet: Codable {
//    let shop_money: DraftOrderMoney
//    let presentment_money: DraftOrderMoney
//}
////done
//
//struct DraftOrderMoney: Codable {
//    let amount: String
//    let currency_code: String
//}

struct DraftOrderCustomer: Codable {
    let id: Int?
    let email: String?
    let created_at: String?
    let updated_at: String?
    let first_name: String?
    let last_name: String?
    let orders_count: Int?
    let state: String?
    let total_spent: String?
    let last_order_id: Int?
    let note: String?
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let tags: String?
    let last_order_name: String?
    let currency: String?
    let phone: String?
    let tax_exemptions: [String]?
    let email_marketing_consent: DraftOrderMarketingConsent?
    let sms_marketing_consent: DraftOrderMarketingConsent?
    let admin_graphql_api_id: String?
    let default_address: Address?
}

struct DraftOrderMarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
    let consent_collected_from: String?
}

//done
struct DraftOrderTaxLine: Codable {
    let rate: Double?
    let title: String?
    let price: String?
}


//struct Order: Codable {
//    let id: Int?
//    let admin_graphql_api_id: String?
//    let app_id: Int?
//    let browser_ip: String?
//    let buyer_accepts_marketing: Bool?
//    let cancel_reason: String?
//    let cancelled_at: String?
//    let cart_token: String?
//    let checkout_id: String?
//    let checkout_token: String?
//    let client_details: String?
//    let closed_at: String?
//    let company: String?
//    let confirmation_number: String?
//    let confirmed: Bool?
//    let contact_email: String?
//    let created_at: String?
//    let currency: String?
//    let current_subtotal_price: String?
//    let current_subtotal_price_set: PriceSet?
//    let current_total_additional_fees_set: PriceSet?
//    let current_total_discounts: String?
//    let current_total_discounts_set: PriceSet?
//    let current_total_duties_set: PriceSet?
//    let current_total_price: String?
//    let current_total_price_set: PriceSet?
//    let current_total_tax: String?
//    let current_total_tax_set: PriceSet?
//    let customer_locale: String?
//    let device_id: String?
//    let discount_codes: [DraftOrderDiscount]?
//    let email: String?
//    let estimated_taxes: Bool?
//    let financial_status: String?
//    let fulfillment_status: String?
//    let landing_site: String?
//    let landing_site_ref: String?
//    let location_id: String?
//    let merchant_of_record_app_id: String?
//    let name: String
//    let note: String?
//    let note_attributes: [String]?
//    let number: Int?
//    let order_number: Int?
//    let order_status_url: String?
//    let original_total_additional_fees_set: PriceSet?
//    let original_total_duties_set: PriceSet?
//    let payment_gateway_names: [String]?
//    let phone: String?
//    let po_number: String?
//    let presentment_currency: String?
//    let processed_at: String?
//    let reference: String?
//    let referring_site: String?
//    let source_identifier: String?
//    let source_name: String
//    let source_url: String?
//    let subtotal_price: String?
//    let subtotal_price_set: PriceSet?
//    let tags: String?
//    let tax_exempt: Bool?
//    let tax_lines: [TaxLine]?
//    let taxes_included: Bool?
//    let test: Bool?
//    let token: String?
//    let total_discounts: String?
//    let total_discounts_set: PriceSet?
//    let total_line_items_price: String?
//    let total_line_items_price_set: PriceSet?
//    let total_outstanding: String?
//    let total_price: String?
//    let total_price_set: PriceSet?
//    let total_shipping_price_set: PriceSet?
//    let total_tax: String?
//    let total_tax_set: PriceSet?
//    let total_tip_received: String?
//    let total_weight: Int?
//    let updated_at: String?
//    let user_id: String?
//    let billing_address: String?
//    let customer: String?
//    let discount_applications: [String]?
//    let fulfillments: [String]?
//    let line_items: [DraftOrderLineItem]?
//    let payment_terms: String?
//    let refunds: [String]?
//    let shipping_address: String?
//    let shipping_lines: [String]?
//}

struct PriceSet: Codable {
    let shop_money: Money
    let presentment_money: Money
}

struct Money: Codable {
    let amount: String
    let currency_code: String
}


struct TaxLine: Codable {
    let price: String
    let rate: Double
    let title: String
    let price_set: PriceSet
    let channel_liable: Bool
}
