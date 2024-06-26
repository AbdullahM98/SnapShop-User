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
    let reviews:[String] = ["Fantastic product! It exceeded my expectations in terms of quality and performance.","Great value for money. This product is a game-changer.","Disappointing. It didn't work as advertised.","Highly recommended. Sturdy build and easy to use.","Not bad, but there are better options available.","Excellent customer service. They resolved my issue promptly.","Perfect for my needs. I use it every day without any issues.", "Could be better. The design needs improvement.", "I'm impressed! It arrived earlier than expected.", "Poor quality. It broke after a few uses.", "Exactly what I was looking for. Works like a charm.", "Too expensive for what it offers. I expected more.", "Compact and lightweight. Ideal for travel.","Needs clearer instructions. I had trouble setting it up.", "Good buy. It's durable and reliable.", "Not suitable for heavy-duty use. It's more for light tasks.","Great addition to my kitchen gadgets. Makes cooking easier.", "I wish I bought it sooner. It simplifies my daily routine.", "Average product. It does the job but nothing extraordinary.","Impressive build quality. Feels like it will last a long time."
    ]
    let reviewers:[String] = ["Abdullah Essam","Al-Hussein Abdulaziz","Ahmed Fekry","Mostafa Sobaih","Ibrahim Mareay","Micheal Magdy","Ramez Hamdi","Mohamed Abdo","Hadir Elnajdy","Aya Hany","Shimaa Samy","Raneem Ashraf","Marwa Mohamed","Rwan Elmatry","Mayar Mohamed","Nareman Sharkan"]
    let rating:[String] = ["4.9","4.7","4.8","4.6","4.5","4.3","4.2","4.1","4.0","5.0","3.9","3.8","3.7","3.6","3.5"]
    @Published var orderToPost:DraftOrderItemDetails?
    @Published var orderToUpdate:DraftOrderItemDetails?
    @Published var vendorTitle:String = "Nike"
    @Published var currentCurrency:String = "USD"
    @Published var price:String = "300.00"
    @Published var availbleQuantity : String?  = "30"
    @Published var inventoryQuantity  = 1
    @Published var pickedQuantity  = 1
    @Published var productTitle  = "T-shirt with long sleeves and pocket an sth else "
    @Published var productDecription  = "Experience ultimate comfort and effortless style with our Oversized T-Shirt. Made from high-quality, breathable cotton, this T-shirt is designed to provide a relaxed fit that drapes beautifully over any body type. Whether you're lounging at home, running errands, or meeting friends, this versatile piece is perfect for any casual occasion."
    @Published var selectedColor: Color? = nil
    @Published var selectedSize: String? = nil
    @Published var isFavorite :Bool = false
    @Published var product: ProductEntity?
    @Published var productModel: ProductModel?
    @Published var errorMessage: String?
    @Published var hasOptions:Bool = false
    @Published var imgUrl :String?
    @Published var images :[String]? = []
    @Published var colors :[Color]? = []
    @Published var sizes :[String]? = []
    @Published var isLoading = true
    var fireStoreManager : FirestoreManager?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchProductByID(_ productID: String) {
        self.isLoading = true
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
                    
                    self?.productModel = productResponse.product!
                    self?.product = self?.convertToEntity(from: productResponse.product!)
                    self?.inventoryQuantity  = self?.productModel?.variants?.first?.inventory_quantity ?? 1
                    self?.setUpUI(product: (self?.product)!)
                    print(productResponse.product?.product_type ?? "No product type")
                    self?.isLoading = false
                }
            })
            .store(in: &cancellables)
    }
    
    func convertToEntity(from model: ProductModel) -> ProductEntity {
        let imageSources = model.images?.compactMap { $0.src } ?? []
        
        let entity = ProductEntity(
            userId: UserDefaults.standard.integer(forKey: Support.userID).description,
            product_id: model.id?.description,
            variant_Id: model.variants?.first?.id?.description,
            title: model.title,
            body_html: model.body_html,
            vendor: model.vendor,
            product_type: model.product_type,
            inventory_quantity: model.variants?.first?.inventory_quantity?.description,
            tags: model.tags,
            price: model.variants?.first?.price,
            images: imageSources,
            isFav: AppCoreData.shared.checkProductIfFav(productId: model.id?.description ?? "0")
        )
        
        self.images = imageSources
        print("is product fav ?? \(entity.isFav ?? false)")
        return entity
    }
    
    
    func setUpUI(product: ProductEntity) {
        print("Setting up UI with product ID: \(product.product_id ?? "0")")
        self.vendorTitle = product.vendor ?? "Unknown"
        self.productDecription = product.body_html ?? "No Description"
        self.productTitle = product.title ?? "NO title"
        self.price = product.price ?? "30"
        self.imgUrl = product.images?.first
        self.isFavorite = product.isFav ?? false
        self.availbleQuantity = product.inventory_quantity ?? "20"
        
        
        if productModel?.options?.count != 0 {
            self.hasOptions = true
        }
        guard let options = productModel?.options else {
            self.hasOptions = false
            return }
        for option in options {
            if option.name == "Size" {
                self.sizes = option.values
            } else if option.name == "Color" {
                self.colors = self.getColors(option: option)
            }
        }
        
    }
    func getColors(option:Option) ->[Color]{
        var colors :[Color] = []
        print("color count is \(option.values.count)")
        if option.name == "Color" {
            for val in option.values {
                switch val {
                case "red":
                    colors.append(Color.red)
                case "black":
                    colors.append(Color.black)
                case "gray":
                    colors.append(Color.gray)
                case "white":
                    colors.append(Color.white)
                case "blue":
                    colors.append(Color.blue)
                case "green":
                    colors.append(Color.green)
                case "yellow":
                    colors.append(Color.yellow)
                default:
                    colors.append(Color.purple)
                }
            }
        }
        return colors
    }
    
    func addLocalFavProduct(product: ProductEntity) {
        fireStoreManager = FirestoreManager()
        // Check if product already exists
        if !AppCoreData.shared.isProductInFavorites(product: product) {
            AppCoreData.shared.addFavProduct(favProduct: product)
        } else {
            print("Product already in favorites, not adding again.")
        }
    }
    func removeFromFavLocal(product:ProductEntity){
        fireStoreManager = FirestoreManager()
        // fireStoreManager?.removeProductFromFavRemote(productId: id)
        AppCoreData.shared.deleteProduct(product: product)
    }
    
    func prepareDraftOrderToPost(){
        print("picked \(pickedQuantity)")
        guard let productToPost = productModel else { return }
        //get Customer ID
        guard let customerID = UserDefaultsManager.shared.getUserId(key: Support.userID) else { return }
        
        let userOrder = DraftOrderItem(draft_order: DraftOrderItemDetails(id: nil, note: nil, email: nil, taxes_included: nil, currency: "USD", invoice_sent_at: nil, created_at: nil, updated_at: nil, tax_exempt: nil, completed_at: nil, name: nil, status: nil, line_items: [DraftOrderLineItem(id: nil, variant_id: productToPost.variants?.first?.id, product_id: productToPost.id, title: productTitle, variant_title: nil, sku: nil, vendor: vendorTitle, quantity: pickedQuantity, requires_shipping: nil, taxable: true, gift_card: nil, fulfillment_service: nil, grams: nil, tax_lines: nil, applied_discount: nil, name: nil, properties: [DraftOrderProperties(name: "productImage", value: imgUrl ?? ""),DraftOrderProperties(name: "Color", value: "\(String(describing: selectedColor) )"),DraftOrderProperties(name: "Size", value: "\(selectedSize ?? "")")], custom: nil, price: price, admin_graphql_api_id: nil)], shipping_address: nil, billing_address: nil, invoice_url: nil, applied_discount: nil, order_id: nil, shipping_line: nil, tax_lines: nil, tags: nil, note_attributes: nil, total_price: nil, subtotal_price: nil, total_tax: nil, payment_terms: nil, presentment_currency: nil, admin_graphql_api_id: nil, customer: DraftOrderCustomer(id: customerID , email: nil, created_at: nil, updated_at: nil, first_name: nil, last_name: nil, orders_count: nil, state: nil, total_spent: nil, last_order_id: nil, note: nil, verified_email: nil, multipass_identifier: nil, tax_exempt: nil, tags: nil, last_order_name: nil, currency: nil, phone: nil, tax_exemptions: nil, email_marketing_consent: nil, sms_marketing_consent: nil, admin_graphql_api_id: nil, default_address: nil), use_customer_default_address: true))
        //if user does not have draft order post one
        if UserDefaultsManager.shared.hasDraft == false {
            print("User Does not have any draft orders \(UserDefaultsManager.shared.hasDraft) must be false, so post order")
            postCardDraftOrder(draftOrder: userOrder)
        }else{
            //else if user have draft order update it
            print("user cant post because User have draft order ==  \(UserDefaultsManager.shared.hasDraft) and his draft Order id is \(UserDefaultsManager.shared.userDraftId ?? 0)")
            guard let itemToUpdate = userOrder.draft_order?.line_items?.first else { return }
            getDraftOrderById(lineItem: itemToUpdate)
        }
    }
    
    func postCardDraftOrder(draftOrder:DraftOrderItem){
        Network.shared.postData(object: draftOrder, to: "\(Support.baseUrl)/draft_orders.json" ){  [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("post draf order with id \(response.draft_order?.id)")
                    self?.orderToPost = response.draft_order
                    UserDefaultsManager.shared.hasDraft = true
                    UserDefaultsManager.shared.userDraftId = response.draft_order?.id
                    UserDefaultsManager.shared.notifyCart = response.draft_order?.line_items?.count
                    print("Posting order with Id : ",self?.orderToPost?.id ?? -1)
                }
            case .failure(let error):
                print("Error posting user order: \(error)")
                print("Error posting user order: \(error.localizedDescription)")
            }
        }
    }
    
    func getDraftOrderById(lineItem:DraftOrderLineItem){
        //get draft orders to
        guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
        print("User Have DraftOrder and its ID1 is : \(orderID)")
        Network.shared.request("\(Support.baseUrl)/draft_orders/\(orderID).json", method: "GET", responseType: DraftOrderItem.self) { [weak self] result in
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
        //check for item if its exist in draft order
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
        
        guard let orderID = UserDefaultsManager.shared.userDraftId else { return }
        let updatedOrder = DraftOrderItem(draft_order: self.orderToUpdate)
        Network.shared.updateData(object: updatedOrder, to: "\(Support.baseUrl)/draft_orders/\(orderID).json" ){result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    print("Draft Updated Successfully")
                    print("User have ",response.draft_order?.line_items?.count ?? 0," line items")
                    UserDefaultsManager.shared.notifyCart = response.draft_order?.line_items?.count
                }
            case .failure(let error):
                print(error.localizedDescription)
                print("Error updating user draft order: \(error)")
            }
        }
    }
    
}

