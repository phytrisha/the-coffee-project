//
//  OrderStore.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 20.05.25.
//


import Foundation
import FirebaseFirestore

// MARK: - OrderStore

class OrderStore: ObservableObject {
    @Published var latestOrders: [Order] = []
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?

    init() {
        fetchLatestOrders()
    }

    func fetchLatestOrders() {
        // Stop listening to previous updates if any
        listenerRegistration?.remove()

        listenerRegistration = db.collection("orders") // Replace "orders" with your collection name
            .order(by: "orderDate", descending: true)
            .limit(to: 5)
            .addSnapshotListener { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    self.latestOrders = [] // Clear orders if no documents are found
                    return
                }

                // Decode the documents into Order objects
                self.latestOrders = documents.compactMap { document in
                    try? document.data(as: Order.self)
                }
            }
    }

    // In a real app, you might want to stop listening when the view disappears
    // or when the object is deinitialized to prevent memory leaks.
    deinit {
        listenerRegistration?.remove()
    }
}
