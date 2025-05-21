//
//  UserProfile.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 19.05.25.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var imageUrl: String? // imageURL might be optional in Firebase
    var userCredits: Int?
    var favoriteShops: [String]?
}
