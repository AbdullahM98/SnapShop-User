//
//  ProfileViewModel.swift
//  SnapShopApp-User
//
//  Created by husayn on 06/06/2024.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var user: CustomerProfileDetails?
    @Published var addresses: [AddressProfileDetails]?
    @Published var addressTextFieldData: String = ""
    @Published var cityTextFieldData: String = ""
    @Published var countryTextFieldData: String = ""
    @Published var zipTextFieldData: String = ""
    @Published var phoneTextFieldData: String = ""
    @Published var phoneAddressTextFieldData: String = ""
    @Published var firstNameTextFieldData: String = ""
    @Published var secondNameTextFieldData: String = ""
    @Published var emailTextFieldData: String = ""
    @Published var orderList : [Order] = []
   
    init() {
        print("PVM INIT")
        fetchUserById(id: "7290794967219")
        fetchUserAddresses()
        fetchCompletedOrders(customerId: "7290794967219")
        postOrder()
    }
    
    func fetchUserById(id: String) {
        let url = "\(Support.baseUrl)/customers/\(id).json"
        Network.shared.request(url, method: "GET", responseType: CustomerProfileRoot.self) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.user = user.customer
                    self?.emailTextFieldData = self?.user?.email ?? ""
                    self?.firstNameTextFieldData = self?.user?.first_name ?? ""
                    self?.secondNameTextFieldData = self?.user?.last_name ?? ""
                    self?.phoneTextFieldData = self?.user?.phone ?? ""
                    
                }
            case .failure(let error):
                print("Error fetching user details: \(error)")
            }
        }
    }
    func fetchUserAddresses(customerId:String = "7290794967219"){
        let url = "\(Support.baseUrl)/customers/\(customerId)/addresses.json"
        Network.shared.request(url, method: "GET", responseType: AddressProfileRoot.self) { [weak self] result in
            switch result {
            case .success(let address):
                DispatchQueue.main.async {
                    self?.addresses = address.addresses
                }
            case .failure(let error):
                print("Error fetching user details: \(error)")
            }
        }
        
    }
    func postUserAddress(customerId:String = "7290794967219"){
        let address = NewAddressRoot(customer_address: NewAddressDetails(id: nil, customer_id: Int(customerId), address1: addressTextFieldData, address2: nil, city: cityTextFieldData, zip: zipTextFieldData, phone: phoneTextFieldData, name: nil, province_code: nil, country_code: "EG", country_name: countryTextFieldData, default: false))
        Network.shared.postData(object: address, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers/\(customerId)/addresses.json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response.customer_address?.name)
                    self?.fetchUserAddresses()
                    
                }
            case .failure(let error):
                print("Error fetching data2: \(error)")
            }
        }
    }
    
    func updateUserData(customerId:String = "7290794967219"){
        let user = CustomerUpdateRequest(customer: CustomerUpdateRequestBody(first_name: firstNameTextFieldData, last_name: secondNameTextFieldData, phone: phoneTextFieldData, email: emailTextFieldData))
        Network.shared.updateData(object: user, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/customers/\(customerId).json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print(response.customer?.email)
                    self?.fetchUserById(id: customerId)
                    
                }
            case .failure(let error):
                print("Error fetching data2: \(error)")
            }
        }
    }
    func deleteAddress(customerId:String = "7290794967219",addressId:Int){
        Network.shared.deleteObject(with: "\(Support.baseUrl)/customers/\(customerId)/addresses/\(addressId).json") { [weak self] result in
            self?.fetchUserAddresses()
            switch result{
            case .none:
                print("Success")
            case .some(let error):
                print("error is \(error.localizedDescription)")
            
            }
            print(result?.localizedDescription)
        }
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
