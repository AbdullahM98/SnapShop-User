//
//  ProductViewModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 06/06/2024.
//

import Foundation
import Combine
import SwiftUI
class ProductDetailViewModel :ObservableObject{
    @Published var orderToPost:DraftOrderItemDetails?
    @Published var orderToUpdate:DraftOrderItemDetails?
    @Published var vendorTitle:String = "Nike"
    @Published var currentCurrency:String = "USD"
    @Published var price:String = "300.00"
    @Published var availbleQuantity  = "30"
    @Published var productTitle  = "T-shirt with long sleeves and pocket an sth else "
    @Published var productDecription  = "Experience ultimate comfort and effortless style with our Oversized T-Shirt. Made from high-quality, breathable cotton, this T-shirt is designed to provide a relaxed fit that drapes beautifully over any body type. Whether you're lounging at home, running errands, or meeting friends, this versatile piece is perfect for any casual occasion."
    @Published var selectedColor: Color? = nil
    @Published var isFavorite :Bool = false
    @Published var product: ProductEntity?
    @Published var productModel: ProductModel?
    @Published var errorMessage: String?
    @Published var imgUrl :String?
    private var cancellables = Set<AnyCancellable>()
    
    func fetchProductByID(_ productID: String) {
        
        Network.shared.getItemByID(productID, type: ProductResponse.self, endpoint: "products")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch product: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] productResponse in
                DispatchQueue.main.async {
                    //    self?.product = productResponse.product
                    self?.setUpUI(product: productResponse.product!)
                    self?.productModel = productResponse.product!
                    print(productResponse.product?.product_type ?? "No product type")
                }
            })
            .store(in: &cancellables)
    }
    
    func setUpUI(product: ProductModel) {
        print("Setting up UI with product ID: \(product.id ?? 0)")
        self.vendorTitle = product.vendor ?? "Unknown"
        self.productDecription = product.body_html ?? "No Description"
        self.productTitle = product.title ?? "NO title"
        self.price = product.variants?[0].price ?? "30"
        self.imgUrl = product.image?.src
        self.availbleQuantity = "\(product.variants?.first?.inventory_quantity ?? 0)"
    }
    
    func addLocalFavProduct(product:ProductEntity){
        AppCoreData.shared.addFavProduct(favProduct: product)
    }
    func removeFromFavLocal(id:String){
        AppCoreData.shared.deleteProductById(id: id)
    }
    
    func prepareDraftOrderToPost(){
        guard let productToPost = productModel else { return }
        guard let customerID = UserDefaultsManager.shared.getUserId(key: Support.userID) else { return }
        
        let userOrder = DraftOrderItem(draft_order: DraftOrderItemDetails(id: nil, note: nil, email: nil, taxes_included: nil, currency: "USD", invoice_sent_at: nil, created_at: nil, updated_at: nil, tax_exempt: nil, completed_at: nil, name: nil, status: nil, line_items: [DraftOrderLineItem(id: nil, variant_id: productToPost.variants?.first?.id, product_id: productToPost.id, title: productTitle, variant_title: nil, sku: nil, vendor: vendorTitle, quantity: 1, requires_shipping: nil, taxable: true, gift_card: nil, fulfillment_service: nil, grams: nil, tax_lines: nil, applied_discount: nil, name: nil, properties: [DraftOrderProperties(name: "productImage", value: imgUrl ?? "")], custom: nil, price: price, admin_graphql_api_id: nil)], shipping_address: nil, billing_address: nil, invoice_url: nil, applied_discount: nil, order_id: nil, shipping_line: nil, tax_lines: nil, tags: nil, note_attributes: nil, total_price: nil, subtotal_price: nil, total_tax: nil, payment_terms: nil, presentment_currency: nil, admin_graphql_api_id: nil, customer: DraftOrderCustomer(id: customerID , email: nil, created_at: nil, updated_at: nil, first_name: nil, last_name: nil, orders_count: nil, state: nil, total_spent: nil, last_order_id: nil, note: nil, verified_email: nil, multipass_identifier: nil, tax_exempt: nil, tags: nil, last_order_name: nil, currency: nil, phone: nil, tax_exemptions: nil, email_marketing_consent: nil, sms_marketing_consent: nil, admin_graphql_api_id: nil, default_address: nil), use_customer_default_address: true))
        if !(UserDefaultsManager.shared.getUserHasDraftOrders(key: "HasDraft") ?? false) {
            print("User Does not have any draft orders \(UserDefaultsManager.shared.getUserHasDraftOrders(key: "HasDraft"))")
            postCardDraftOrder(draftOrder: userOrder)
        }else{
            print("user cant post because User have draft order because  \(UserDefaultsManager.shared.getUserHasDraftOrders(key: "HasDraft")) and his draft Order id is \(UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId"))")
            guard let itemToUpdate = userOrder.draft_order?.line_items?.first else { return }
            getDraftOrderById(lineItem: itemToUpdate)
        }
    }
    
    func postCardDraftOrder(draftOrder:DraftOrderItem){
        Network.shared.postData(object: draftOrder, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders.json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.orderToPost = response.draft_order
                    UserDefaultsManager.shared.setUserHasDraftOrders(key: "HasDraft", value: true)
                    UserDefaultsManager.shared.setUserDraftOrderId(key: "DraftId", value: self?.orderToPost?.id ?? 0)
                    print("Posting order with name : ",self?.orderToPost?.name ?? "-1")
                }
            case .failure(let error):
                print("Error posting user order: \(error)")
                print("Error posting user order: \(error.localizedDescription)")
            }
        }
    }
    
    func getDraftOrderById(lineItem:DraftOrderLineItem){
        guard let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId") else { return }
        print("User Have DraftOrder and its ID is : \(orderID)")
        
        Network.shared.request("https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID).json", method: "GET", responseType: DraftOrderItem.self) { [weak self] result in
            switch result{
            case .success(let order):
                DispatchQueue.main.async {
                    guard let draftOrder = order.draft_order else {return}
                    self?.orderToUpdate = draftOrder
                    self?.updateUserData(lineItem: lineItem)
                }
            case .failure(let err):
                print("Error get the user order : \(err)")
                
                
            }
        }
    }
    
    func updateUserData(lineItem:DraftOrderLineItem){
        print("old order line items before update ",self.orderToUpdate?.line_items?.count ?? 0)
        if let existingIndex = self.orderToUpdate?.line_items?.firstIndex(where: { $0.product_id == lineItem.product_id }) {
            // If it exists, update its quantity
            if let existingQuantity = self.orderToUpdate?.line_items?[existingIndex].quantity {
                self.orderToUpdate?.line_items?[existingIndex].quantity = existingQuantity + (lineItem.quantity ?? 0)
                print("Updated existing line item quantity to \(self.orderToUpdate?.line_items?[existingIndex].quantity ?? 0)")
            }
        } else {
            // If it does not exist, add the new line item
            self.orderToUpdate?.line_items?.append(lineItem)
            print("Added new line item")
        }
        print("old order line item afteer update ",self.orderToUpdate?.line_items?.count ?? 0)
        
        guard let orderID = UserDefaultsManager.shared.getUserDraftOrderId(key: "DraftId") else { return }
        let updatedOrder = DraftOrderItem(draft_order: self.orderToUpdate)
        Network.shared.updateData(object: updatedOrder, to: "https://mad-ism-ios-1.myshopify.com/admin/api/2024-04/draft_orders/\(orderID).json" ){result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Draft Updated Successfully")
                    print("User have ",response.draft_order?.line_items?.count ?? 0," line items")
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("Error updating user draft order: \(error)")
            }
        }
        
        
    }
    
    func setUpUI(product: ProductEntity) {
        print("Setting up UI with product ID: \(product.product_id ?? "0")")
        self.vendorTitle = product.vendor ?? "Unknown"
        self.productDecription = product.body_html ?? "No Description"
        self.productTitle = product.title ?? "NO title"
        self.price = product.price ?? "30"
        self.imgUrl = product.images?.first
    }
    
    
}
