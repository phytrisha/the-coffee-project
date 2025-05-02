//
//  DrinkModel.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import Foundation
import FirebaseFirestore

struct Drink: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var imageUrl: String? // imageURL might be optional in Firebase
    var featured: Bool
    var price: Float
}
