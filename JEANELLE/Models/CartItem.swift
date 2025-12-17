//
//  CartItem.swift
//  JEANELLE
//
//  Created by Zhanel  on 17.12.2025.
//

import Foundation

struct CartItem: Codable, Equatable, Identifiable {
    let id: Int              // same as product id (for Identifiable)
    let product: Product
    var quantity: Int

    init(product: Product, quantity: Int = 1) {
        self.id = product.id
        self.product = product
        self.quantity = max(1, quantity)
    }

    var lineTotal: Double {
        product.priceValue * Double(quantity)
    }
}

