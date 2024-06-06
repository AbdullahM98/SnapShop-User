//
//  BestSellerModel.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 02/06/2024.
//

import Foundation

struct PopularProductsResponse: Codable {
    let products: [PopularProductItem]?
}

struct PopularProductItem: Codable {
    let id: Int?
    let title: String?
    let bodyHtml: String?
    let vendor: String?
    let product_type: String?
    let createdAt: String?
    let handle: String?
    let updatedAt: String?
    let publishedAt: String?
    let templateSuffix: String?
    let tags: String?
    let adminGraphqlApiId: String?
    let variants: [PopularVariant]?
    let options: [PopularOption]?
    let images: [PopularProductImage]?
    let image: PopularProductImage?
}

struct PopularVariant: Codable {
    let id: Int?
    let productId: Int?
    let title: String?
    let price: String?
    let sku: String?
    let position: Int?
    let inventoryPolicy: String?
    let compareAtPrice: String?
    let fulfillmentService: String?
    let inventoryManagement: String?
    let option1: String?
    let option2: String?
    let option3: String?
    let createdAt: String?
    let updatedAt: String?
    let taxable: Bool?
    let barcode: String?
    let grams: Int?
    let imageId: Int?
    let weight: Double?
    let weightUnit: String?
    let inventoryItemId: Int?
    let inventoryQuantity: Int?
    let oldInventoryQuantity: Int?
    let requiresShipping: Bool?
    let adminGraphqlApiId: String?
}

struct PopularOption: Codable {
    let id: Int?
    let productId: Int?
    let name: String?
    let position: Int?
    let values: [String]?
}

struct PopularProductImage: Codable {
    let id: Int?
    let productId: Int?
    let position: Int?
    let createdAt: String?
    let updatedAt: String?
    let alt: String?
    let width: Int?
    let height: Int?
    let src: String?
    let variantIds: [Int]?
    let adminGraphqlApiId: String?
}
