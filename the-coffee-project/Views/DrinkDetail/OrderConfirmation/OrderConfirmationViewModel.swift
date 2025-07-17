//
//  OrderConfirmationViewModel.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 17.07.25.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

@MainActor
class OrderConfirmationViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var address: String = "Loading address..."
    @Published var alertItem: AlertItem?
    @Published private(set) var orderSuccessfullyPlaced = false

    // MARK: - Properties
    private let drink: Drink
    private let cafe: Cafe
    private let authService: AuthService
    private let db = Firestore.firestore()

    var userCredits: Int {
        authService.userProfile?.userCredits ?? 0
    }

    private var currentShopId: String {
        return cafe.id ?? ""
    }
    
    private var currentUserId: String {
        return authService.userProfile?.id ?? ""
    }

    // MARK: - Initialization
    init(drink: Drink, cafe: Cafe, authService: AuthService) {
        self.drink = drink
        self.cafe = cafe
        self.authService = authService
    }

    // MARK: - Public Methods
    
    /// Fetches and sets the human-readable address for the cafe's location.
    func fetchAddress() {
        reverseGeocode(latitude: cafe.lat, longitude: cafe.long) { resolvedAddress in
            self.address = resolvedAddress
        }
    }

    /// Confirms and places the order after validating the scanned QR code.
    /// - Parameter scannedStoreID: The store ID obtained from the QR code scan.
    func confirmOrder(with scannedStoreID: String) async {
        // 1. --- Validate the Scanned QR Code ---
        // Ensure the scanned ID matches the cafe the user is ordering from.
        guard scannedStoreID == self.currentShopId else {
            self.alertItem = AlertContext.invalidQRCode
            return
        }
        
        // 2. --- Pre-computation Checks ---
        guard !self.currentUserId.isEmpty else {
            self.alertItem = AlertContext.invalidUserData
            print("Error: currentUserId is empty.")
            return
        }

        let newOrder = Order(userId: self.currentUserId, shopId: self.currentShopId, item: drink)

        guard let orderData = try? Firestore.Encoder().encode(newOrder) else {
            self.alertItem = AlertContext.orderFailure
            print("Error: Failed to encode order data.")
            return
        }

        // 3. --- Firestore Transaction ---
        // Add the order document to the main "orders" collection.
        do {
            // Await the result from Firestore directly.
            let orderRef = try await db.collection("orders").addDocument(data: orderData)
            
            // The code only continues after the document is successfully created.
            let orderId = orderRef.documentID
            print("Order added with ID: \(orderId)")
            
            // Now perform all subsequent actions.
            await self.performPostOrderActions(orderId: orderId, orderData: orderData)

        } catch {
            // Catch any errors from the `await` call.
            print("Error adding document to 'orders': \(error)")
            self.alertItem = AlertContext.orderFailure
        }
    }
    
    // MARK: - Private Helper Methods

    /// Performs all Firestore writes that should occur after the primary order is created.
    private func performPostOrderActions(orderId: String, orderData: [String: Any]) async {
        // Create a TaskGroup to run Firestore updates concurrently.
        await withTaskGroup(of: Bool.self) { group in
            // Task 1: Decrement user credits.
            group.addTask {
                do {
                    try await self.db.collection("users").document(self.currentUserId).updateData([
                        "userCredits": FieldValue.increment(Int64(-1))
                    ])
                    print("Credits deducted for user \(await self.currentUserId).")
                    return true
                } catch {
                    print("Error deducting credits for user \(await self.currentUserId): \(error)")
                    return false
                }
            }
            
            // Task 2: Add order to the shop's sub-collection.
            group.addTask {
                do {
                    try await self.db.collection("shops").document(self.currentShopId).collection("orders").document(orderId).setData(orderData)
                    print("Order \(orderId) added to shop \(await self.currentShopId)'s orders.")
                    return true
                } catch {
                    print("Error adding order to shop's orders: \(error)")
                    return false
                }
            }
            
            // Task 3: Add order to the user's history sub-collection.
            group.addTask {
                do {
                    try await self.db.collection("users").document(self.currentUserId).collection("orderHistory").document(orderId).setData(orderData)
                    print("Order \(orderId) added to user \(await self.currentUserId)'s order history.")
                    return true
                } catch {
                    print("Error adding order to user's orderHistory: \(error)")
                    return false
                }
            }
        }
        
        // After all tasks are complete, update the UI.
        self.orderSuccessfullyPlaced = true
        self.alertItem = AlertContext.orderSuccess(drinkName: self.drink.name, cafeName: self.cafe.name)
    }
}
