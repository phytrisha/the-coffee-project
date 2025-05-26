//
//  DrinkDetailView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 19.05.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// MARK: - Drink Detail View

struct DrinkDetailView: View {
    @EnvironmentObject var authService: AuthService
    
    var drink: Drink
    var cafe: Cafe
    
    let drinkImageWidth: CGFloat = 128.0
    let drinkImageHeight: CGFloat = 128.0
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: drink.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: drinkImageWidth, height: drinkImageHeight)
                        .padding(.top)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: drinkImageWidth, height: drinkImageHeight)
                        .cornerRadius(999)
                        .clipped()
                        .padding(.top)
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit() // Use scaledToFit for system images
                        .frame(width: drinkImageWidth, height: drinkImageHeight)
                        .cornerRadius(999)
                        .foregroundColor(.gray)
                        .padding(.top)
                @unknown default:
                    // Handle potential future cases
                    EmptyView()
                }
            }
            Text(drink.name)
                .font(Font.custom("Crimson Pro Medium", size: 28))
                .padding(.horizontal)
                .padding(.top)
                .frame(maxWidth: .infinity)
            Text(drink.description)
                .font(.subheadline)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .foregroundColor(.gray)
                .lineLimit(4)

            Spacer()
            
            Button {
                if let profile = authService.userProfile {
                    if let userCredits = profile.userCredits {
                        if userCredits > 0 {
                            showingSheet = true
                        }
                    }
                } else {
                    print("Not enough credits!")
                }
            } label: {
                Text("Redeem Drink")
                    .padding(12)
                    .frame(width: 370, alignment: .center)
                    .background(.accent)
                    .foregroundColor(.white)
                    .font(Font.custom("Crimson Pro Medium", size: 20))
                    .cornerRadius(12)
                    .padding(.bottom, 16)
                    .padding(.horizontal)
            }
        }
        .sheet(isPresented: $showingSheet) {
            OrderConfirmationView(showingSheet: $showingSheet, drink: drink, cafe: cafe, currentUserId: authService.currentUser?.uid ?? "", currentShopId: cafe.id ?? "")
        }
    }
}

// MARK: - Order Confirmation View

struct OrderConfirmationView: View {
    @EnvironmentObject var authService: AuthService

    @Binding var showingSheet: Bool
    @State private var showingAlert = false
    
    var drink: Drink
    var cafe: Cafe
    
    @State private var address: String = "Loading address..."

    let currentUserId: String
    let currentShopId: String
    let db = Firestore.firestore()

    @State private var orderFeedbackMessage: String? = nil // For user feedback (Future release)

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: URL(string: drink.imageUrl ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                            .clipped()
                            .padding(.horizontal)
                    case .failure:
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit() // Use scaledToFit for system images
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .cornerRadius(8)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    @unknown default:
                        // Handle potential future cases
                        EmptyView()
                    }
                }
                
                // Drink Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "cup.and.saucer.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Drink")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(drink.name)
                        .font(Font.custom("Crimson Pro Medium", size: 28))
                }
                .padding(.horizontal)

                // Location Details
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "location.fill")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("Location")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(cafe.name)
                        .font(Font.custom("Crimson Pro Medium", size: 28))
                    Text(address)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                Spacer()
                
                Text("Show to the Barista to confirm your order.")
                    .font(.subheadline)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
                    .lineLimit(2)

// In the future, change this to Swipe to Confirm
//                Button {
//                    confirmOrder()
//                } label: {
//                    Text("Confirm Order")
//                        .padding(12)
//                        .frame(width: 370, alignment: .center)
//                        .background(.accent)
//                        .foregroundColor(.white)
//                        .font(Font.custom("Crimson Pro Medium", size: 20))
//                        .cornerRadius(12)
//                        .padding(.bottom, 16)
//                        .padding(.horizontal)
//                }
//
                ConfirmationSlider(text: "Slide to confirm", foregroundColor: .accent, action: {
                    confirmOrder()
                    showingAlert = true
                    print("Accept action triggered!")
                })
            }
            .navigationTitle("Confirm your order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSheet = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                reverseGeocode(latitude: cafe.lat, longitude: cafe.long) { resolvedAddress in
                    self.address = resolvedAddress // Update the state variable with the result
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Order Confirmed"),
                    message: Text("You successfully ordered a " + drink.name + " at " + cafe.name),
                    dismissButton: .default(Text("OK"), action: {
                        showingSheet = false
                    })
                )
            }
        }
    }
    
    // MARK: - Firestore Order Logic

    func confirmOrder() {
        // Essential check: Ensure userId and shopId are available
        guard !currentUserId.isEmpty, !currentShopId.isEmpty else {
            orderFeedbackMessage = "Error: User or shop ID not available."
            print("Error: currentUserId or currentShopId is empty.")
            return
        }

        let singleItem = drink
        let newOrder = Order(userId: currentUserId, shopId: currentShopId, item: singleItem)

        // Convert the Order struct to a dictionary for Firestore
        guard let orderData = try? Firestore.Encoder().encode(newOrder) else {
            orderFeedbackMessage = "Error: Could not encode order data."
            print("Error: Failed to encode order data.")
            return
        }

        // Add the order to the main "orders" collection
        var orderRef: DocumentReference? = nil
        orderRef = db.collection("orders").addDocument(data: orderData) { err in
            if let err = err {
                orderFeedbackMessage = "Error confirming order: \(err.localizedDescription)"
                print("Error adding document to 'orders': \(err)")
            } else {
                guard let orderId = orderRef?.documentID else {
                    orderFeedbackMessage = "Success! But failed to get order ID."
                    print("Order added, but document ID is nil.")
                    return
                }

                self.orderFeedbackMessage = "Order confirmed successfully!"
                print("Order added with ID: \(orderId)")
                
                // --- Deduct User Credits ---
                self.db.collection("users").document(self.currentUserId).updateData([
                    "userCredits": FieldValue.increment(Int64(-1)) // Safely decrement credits by 1
                ]) { creditsErr in
                    if let creditsErr = creditsErr {
                        self.orderFeedbackMessage = "Order confirmed, but failed to deduct credits: \(creditsErr.localizedDescription)"
                        print("Error deducting credits for user \(self.currentUserId): \(creditsErr)")
                    } else {
                        self.orderFeedbackMessage = "Order confirmed and credits deducted successfully!"
                        print("Credits deducted for user \(self.currentUserId).")

                        self.db.collection("shops").document(self.currentShopId).collection("orders").document(orderId).setData(orderData) { shopErr in
                            if let shopErr = shopErr {
                                print("Error adding order to shop's orders: \(shopErr)")
                            } else {
                                print("Order \(orderId) added to shop \(self.currentShopId)'s orders.")
                            }
                        }

                        self.db.collection("users").document(self.currentUserId).collection("orderHistory").document(orderId).setData(orderData) { userErr in
                            if let userErr = userErr {
                                print("Error adding order to user's orderHistory: \(userErr)")
                            } else {
                                print("Order \(orderId) added to user \(self.currentUserId)'s order history.")
                            }
                        }

// Optional: Dismiss the sheet after a short delay
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                            self.showingSheet = false
//                        }
                    }
                }
            }
        }
    }
}
