//
//  ProductModel.swift
//  SnapShopApp-User
//
//  Created by Abdullah Essam on 06/06/2024.
//


import Foundation
struct ProductResponse: Codable {
    let product: ProductModel?
}

struct ProductModel: Codable {
    let id: Int?
    let title: String?
    let body_html: String?
    let vendor: String?
    let product_type: String?
    let tags: String?
    let status: String?
    let variants: [Variant]?
    let options: [Option]?
    let images: [product_Image]?
    let image: product_Image?
}

struct Variant: Codable {
    let id: Int?
    let product_id: Int?
    let title: String?
    let price: String?
    let sku: String?
    let position: Int?
    let inventory_item_id: Int?
    let inventory_quantity: Int?
    let old_inventory_quantity: Int?
    let image_id: Int?
}




struct Option: Codable {
    let id: Int
    let product_id: Int
    let name: String
    let position: Int
    let values: [String]
}

struct product_Image: Codable {
    let id: Int
    let alt: String?
    let position: Int
    let product_id: Int
    let width: Int
    let height: Int
    let src: String
    let variant_ids: [Int]
}

struct ProductEntity {
    let userId:String?
    let id: String?
    let variant_Id :String?
    let title: String?
    let body_html: String?
    let vendor: String?
    let product_type: String?
    let inventory_quantity: String?
    let tags: String?
    let price: String?
    let images: [String]?
    var isFav : Bool? = false
}
