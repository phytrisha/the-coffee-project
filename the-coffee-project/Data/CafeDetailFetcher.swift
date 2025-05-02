//
//  CafeDetailFetcher.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import Foundation
import FirebaseFirestore

class CafeDetailFetcher: ObservableObject {
    @Published var drinks: [Drink] = [] // Array to hold drinks for a specific cafe
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    // Function to fetch drinks for a given cafe ID
    func fetchDrinks(forCafeId cafeId: String) {
        // Stop listening to previous drinks if the cafe changes
        listenerRegistration?.remove()
        drinks = [] // Clear previous drinks when fetching for a new cafe

        // Construct the reference to the drinks subcollection
        let drinksCollectionRef = db.collection("shops").document(cafeId).collection("drinks")

        listenerRegistration = drinksCollectionRef
            .addSnapshotListener { (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching drinks subcollection: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self.drinks = documents.compactMap { document in
                    do {
                        // Decode each drink document into a Drink object
                        return try document.data(as: Drink.self)
                    } catch {
                        print("Error decoding drink document \(document.documentID): \(error.localizedDescription)")
                        return nil // Skip this drink if decoding fails
                    }
                }

                // Print fetched drinks (optional, for debugging)
                print("Fetched \(self.drinks.count) drinks for cafe \(cafeId)")
            }
    }

    // Clean up the listener when the object is deallocated
    deinit {
        listenerRegistration?.remove()
    }
}
