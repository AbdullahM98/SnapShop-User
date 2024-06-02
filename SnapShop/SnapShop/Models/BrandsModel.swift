//
//  BrandsModel.swift
//  SnapShop
//
//  Created by Mostfa Sobaih on 01/06/2024.
//

import Foundation

struct BrandsResponse: Codable {
    let smart_collections: [SmartCollectionsItem]?
}

struct SmartCollectionsItem: Codable {
    let image: BrandImage?
    let bodyHtml, handle: String?
    let rules: [RulesItem]?
    let title, publishedScope: String?
    let templateSuffix: String?
    let updatedAt: String?
    let disjunctive: Bool?
    let adminGraphqlApiId: String?
    let id: Int?
    let publishedAt: String?
    let sortOrder: String?
}

struct RulesItem: Codable {
    let condition, column, relation: String?
}

struct BrandImage: Codable {
    let src: String?
    let alt: String?
    let width: Int?
    let createdAt: String?
    let height: Int?
}



