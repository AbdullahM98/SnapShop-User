//
//  DrftOrdersModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 08/06/2024.
//

import Foundation
struct DraftOrder: Codable {
    let draft_order: DraftOrderDetails?
}
struct DraftOrderResponse:Codable{
    let draft_orders:[DraftOrderDetails]?
}
struct DraftOrderDetails: Codable {
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
    let line_items: [LineItem]?
    let shipping_address: AddressForDraftOrder?
    let billing_address: AddressForDraftOrder?
    let invoice_url: String?
    let applied_discount: String?
    let order_id: Int?
    let shipping_line: String?
    let tax_lines: [String]?
    let tags: String?
    let note_attributes: [String]?
    let total_price: String?
    let subtotal_price: String?
    let total_tax: String?
    let payment_terms: String?
    let admin_graphql_api_id: String?
    let customer: CustomerForDraftOrder?
    let use_customer_default_address:Bool?
}

struct LineItem: Codable {
    let id: Int?
    let variant_id: Int?
    let product_id: Int?
    let title: String?
    let variant_title: String?
    let sku: String?
    let vendor: String?
    let quantity: Int?
    let requires_shipping: Bool?
    let taxable: Bool?
    let gift_card: Bool?
    let fulfillment_service: String?
    let grams: Int?
    let tax_lines: [String]?
    let applied_discount: String?
    let name: String?
    let properties: [String]?
    let custom: Bool?
    let price: String?
    let admin_graphql_api_id: String?
}

struct AddressForDraftOrder: Codable {
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
    let latitude: String?
    let longitude: String?
    let name: String?
    let country_code: String?
    let province_code: String?
}

struct CustomerForDraftOrder: Codable {
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
    let email_marketing_consent: MarketingConsent?
    let sms_marketing_consent: MarketingConsent?
    let admin_graphql_api_id: String?
    let default_address: Address?
}

struct MarketingConsent: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
    let consent_collected_from: String?
}

struct Resp:Codable{
    let draft_orders:[DraftOrderResponse2]?
}


struct DraftOrderResponse2: Codable {
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
    let line_items: [LineItemResponse]?
    let shipping_address: AddressResponseForDraftOrders?
    let billing_address: AddressResponseForDraftOrders?
    let invoice_url: String?
    let applied_discount: String?
    let order_id: String?
    let shipping_line: String?
    let tax_lines: [TaxLine]?
    let tags: String?
    let note_attributes: [String]?
    let total_price: String?
    let subtotal_price: String?
    let total_tax: String?
    let payment_terms: String?
    let admin_graphql_api_id: String?
    let customer: CustomerResponseForDraftOrders?
}

struct LineItemResponse: Codable {
    let id: Int?
    let variant_id: Int?
    let product_id: Int?
    let title: String?
    let variant_title: String?
    let sku: String?
    let vendor: String?
    let quantity: Int?
    let requires_shipping: Bool?
    let taxable: Bool?
    let gift_card: Bool?
    let fulfillment_service: String?
    let grams: Int?
    let tax_lines: [TaxLine]?
    let applied_discount: String?
    let name: String?
    let properties: [String]?
    let custom: Bool?
    let price: String?
    let admin_graphql_api_id: String?
}

struct AddressResponseForDraftOrders: Codable {
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

struct TaxLine: Codable {
    let rate: Double?
    let title: String?
    let price: String?
}

struct CustomerResponseForDraftOrders: Codable {
    let id: Int?
    let email: String?
    let created_at: String?
    let updated_at: String?
    let first_name: String?
    let last_name: String?
    let orders_count: Int?
    let state: String?
    let total_spent: String?
    let last_order_id: String?
    let note: String?
    let verified_email: Bool?
    let multipass_identifier: String?
    let tax_exempt: Bool?
    let tags: String?
    let last_order_name: String?
    let currency: String?
    let phone: String?
    let tax_exemptions: [String]?
    let email_marketing_consent: MarketingConsentResponse?
    let sms_marketing_consent: MarketingConsentResponse?
    let admin_graphql_api_id: String?
    let default_address: Address?
}

struct MarketingConsentResponse: Codable {
    let state: String?
    let opt_in_level: String?
    let consent_updated_at: String?
    let consent_collected_from: String?
}
