//
//  FirebaseManager.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 21.05.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager: ObservableObject {
    let db = Firestore.firestore()

    // Function to add a cafe to favorites array
    func addCafeToFavorites(cafeId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        let userDocRef = db.collection("users").document(userId)

        userDocRef.updateData([
            "favoriteShops": FieldValue.arrayUnion([cafeId])
        ]) { error in
            if let error = error {
                print("Error adding cafe to favorites array: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Cafe \(cafeId) successfully added to favorites array for user \(userId)!")
                completion(.success(()))
            }
        }
    }

    // Function to remove a cafe from favorites array
    func removeCafeFromFavorites(cafeId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        let userDocRef = db.collection("users").document(userId)

        // Use FieldValue.arrayRemove to remove the cafeId from the 'favoriteShops' array
        userDocRef.updateData([
            "favoriteShops": FieldValue.arrayRemove([cafeId])
        ]) { error in
            if let error = error {
                print("Error removing cafe from favorites array: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Cafe \(cafeId) successfully removed from favorites array for user \(userId)!")
                completion(.success(()))
            }
        }
    }

    // Function to fetch the current user's favorite cafe IDs
    func fetchFavoriteCafeIds(completion: @escaping (Result<[String], Error>) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"])))
            return
        }

        let userDocRef = db.collection("users").document(userId)

        userDocRef.getDocument { documentSnapshot, error in
            if let error = error {
                print("Error fetching user document: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            guard let document = documentSnapshot, document.exists else {
                print("User document does not exist.")
                // If document doesn't exist, favorites array is empty
                completion(.success([]))
                return
            }

            // Get the 'favoriteShops' array from the document data
            if let favoriteShops = document.data()?["favoriteShops"] as? [String] {
                completion(.success(favoriteShops))
            } else {
                // If the field doesn't exist or isn't an array of strings, return empty
                print("Favorite cafes field not found or is not an array of strings.")
                completion(.success([]))
            }
        }
    }
}
