//
//  Product.swift
//  JEANELLE
//
//  Created by Zhanel  on 17.12.2025.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
    let id: Int
    let brand: String?
    let name: String
    let price: String?
    let priceSign: String?
    let currency: String?
    let imageLink: String?
    let productType: String?
    let productDescription: String?

   
    var priceValue: Double {
        guard let price, let v = Double(price.trimmingCharacters(in: .whitespacesAndNewlines)) else { return 0 }
        return v
    }

    enum CodingKeys: String, CodingKey {
        case id
        case brand
        case name
        case price
        case priceSign = "price_sign"
        case currency
        case imageLink = "image_link"
        case productType = "product_type"
        case productDescription = "description"
    }
}

