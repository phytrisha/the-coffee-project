//
//  CafeFetcher.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import Foundation
import FirebaseFirestore

class CafeFetcher: ObservableObject {
    @Published var cafes: [Cafe] = [] // Array to hold fetched cafes
    private var db = Firestore.firestore() // Firestore database reference
    private var listenerRegistration: ListenerRegistration? // To manage real-time listener

    init() {
        fetchCafes() // Fetch data when the fetcher is initialized
    }

    // Function to fetch cafes from Firestore
    func fetchCafes() {
        // Remove previous listener if it exists (important for real-time updates)
        listenerRegistration?.remove()

        listenerRegistration = db.collection("shops")
                .addSnapshotListener { (querySnapshot, error) in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }

                    self.cafes = documents.compactMap { document in
                        do {
                            let cafe = try document.data(as: Cafe.self)
                            return cafe
                        } catch {
                            print("Error decoding document \(document.documentID): \(error.localizedDescription)")
                            // Pay close attention to decoding errors here!
                            return nil
                        }
                    }
                }
    }

    // Clean up the listener when the object is deallocated
    deinit {
        listenerRegistration?.remove()
    }
}
