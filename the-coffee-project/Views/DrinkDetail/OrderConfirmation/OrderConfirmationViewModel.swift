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
    @Published var address: String = "Loading address..."
    @Published var alertItem: AlertItem?
    @Published var orderFeedbackMessage: String?
    @Published private(set) var orderSuccessfullyPlaced = false

    private let drink: Drink
    private let cafe: Cafe
    private let authService: AuthService
    
    private var currentShopId: String {
        return cafe.id ?? ""
    }
    private var currentUserId: String {
        return authService.userProfile?.id ?? ""
    }
    
    private let db = Firestore.firestore()
    
    // Note: AuthService is injected for testability and environment compatibility.
    init(drink: Drink, cafe: Cafe, authService: AuthService) {
        self.drink = drink
        self.cafe = cafe
        self.authService = authService
    }
    
    func fetchAddress() {
        reverseGeocode(latitude: cafe.lat, longitude: cafe.long) { resolvedAddress in
            self.address = resolvedAddress // Update the state variable with the result
        }
    }
    
    func confirmOrder() {
        // Essential check: Ensure userId and shopId are available
        guard !self.currentUserId.isEmpty, !self.currentShopId.isEmpty else {
            orderFeedbackMessage = "Error: User or shop ID not available."
            print("Error: currentUserId or currentShopId is empty.")
            return
        }

        let singleItem = drink
        let newOrder = Order(userId: self.currentUserId, shopId: self.currentShopId, item: singleItem)

        // Convert the Order struct to a dictionary for Firestore
        guard let orderData = try? Firestore.Encoder().encode(newOrder) else {
            orderFeedbackMessage = "Error: Could not encode order data."
            print("Error: Failed to encode order data.")
            return
        }

        let db = self.db

        // Add the order to the main "orders" collection
        var orderRef: DocumentReference? = nil
        orderRef = db.collection("orders").addDocument(data: orderData) { err in
            if let err = err {
                Task { @MainActor in
                    self.orderFeedbackMessage = "Error confirming order: \(err.localizedDescription)"
                }
                print("Error adding document to 'orders': \(err)")
            } else {
                guard let orderId = orderRef?.documentID else {
                    Task { @MainActor in
                        self.orderFeedbackMessage = "Success! But failed to get order ID."
                    }
                    print("Order added, but document ID is nil.")
                    return
                }

                Task { @MainActor in
                    self.orderFeedbackMessage = "Order confirmed successfully!"
                }
                print("Order added with ID: \(orderId)")
                
                // --- Deduct User Credits ---
                let userId = self.currentUserId
                let shopId = self.currentShopId
                
                db.collection("users").document(userId).updateData([
                    "userCredits": FieldValue.increment(Int64(-1)) // Safely decrement credits by 1
                ]) { creditsErr in
                    if let creditsErr = creditsErr {
                        Task { @MainActor in
                            self.orderFeedbackMessage = "Order confirmed, but failed to deduct credits: \(creditsErr.localizedDescription)"
                        }
                        print("Error deducting credits for user \(userId): \(creditsErr)")
                    } else {
                        Task { @MainActor in
                            self.orderFeedbackMessage = "Order confirmed and credits deducted successfully!"
                        }
                        print("Credits deducted for user \(userId).")

                        db.collection("shops").document(shopId).collection("orders").document(orderId).setData(orderData) { shopErr in
                            if let shopErr = shopErr {
                                print("Error adding order to shop's orders: \(shopErr)")
                            } else {
                                print("Order \(orderId) added to shop \(shopId)'s orders.")
                            }
                        }

                        db.collection("users").document(userId).collection("orderHistory").document(orderId).setData(orderData) { userErr in
                            if let userErr = userErr {
                                print("Error adding order to user's orderHistory: \(userErr)")
                            } else {
                                print("Order \(orderId) added to user \(userId)'s order history.")
                            }
                        }

//                      Optional: Dismiss the sheet after a short delay
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            self.showingSheet = false
//                        }
                    }
                }
            }
        }
    }
}

// You can also create a separate file for these helper structs
struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButtonText: Text
}

struct AlertContext {
    static let invalidUserData = AlertItem(title: Text("Invalid User Data"), message: Text("There was a problem with your user information."), dismissButtonText: Text("OK"))
    static func orderSuccess(drinkName: String, cafeName: String) -> AlertItem {
        AlertItem(
            title: Text("Order Confirmed"),
            message: Text("Your \(drinkName) from \(cafeName) has been ordered successfully."),
            dismissButtonText: Text("Great!")
        )
    }
    static let orderFailure = AlertItem(title: Text("Order Failed"), message: Text("There was a problem placing your order."), dismissButtonText: Text("OK"))
}

