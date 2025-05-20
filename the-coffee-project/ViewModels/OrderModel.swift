//
//  OrderModel.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 20.05.25.
//

import Foundation
import FirebaseFirestore

// Represents a single item in the order
struct OrderItem: Codable {
    var name: String
    var quantity: Int
    var price: Float
}

// Represents the entire order (even if it contains only one item for now)
struct Order: Codable, Identifiable {
    @DocumentID var id: String?
    var userId: String
    var shopId: String
    var items: [OrderItem] // Array, since in the future, more items could be included
    var totalAmount: Float
    var orderDate: Date
    var status: String

    // Initializer to create a new order
    init(userId: String, shopId: String, item: OrderItem) {
        self.userId = userId
        self.shopId = shopId
        self.items = [item] // Always store a single item in the array for this case
        self.totalAmount = item.price * Float(item.quantity)
        self.orderDate = Date()
        self.status = "completed" // Initial status
    }
}
