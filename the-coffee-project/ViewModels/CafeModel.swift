//
//  CafeModel.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import Foundation
import FirebaseFirestore

struct Cafe: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var imageUrl: String? // imageURL might be optional in Firebase
}
