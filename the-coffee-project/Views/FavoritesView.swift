//
//  FavoritesView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct FavoritesView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject var fetcher = CafeFetcher()
    @StateObject private var firebaseManager = FirebaseManager()

    var body: some View {
        NavigationView {
            Group {
                if let profile = authService.userProfile {
                    if var shops = profile.favoriteShops {
                        if !shops.isEmpty {
                            List {
                                ForEach(shops, id: \.self) { favoriteShopID in
                                    if let cafe = fetcher.cafes.first(where: { $0.id == favoriteShopID }) {
                                        NavigationLink(destination: CafeDetailView(cafe: cafe)) {
                                            CafeListItem(cafe: cafe)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                        .listRowSeparator(.hidden)
                                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                        .contentShape(Rectangle())
                                        .padding(.vertical, 8)
                                    }
                                }
                                .onDelete { indexSet in
                                    deleteFavoriteShop(at: indexSet, in: &shops)
                                }
                            }
                            .listStyle(.plain)
                            .navigationTitle("Favorites")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    EditButton() // This button automatically toggles edit mode for the List
                                }
                            }
                        } else {
                            Text("No favorite shops added yet.")
                                .foregroundColor(.gray)
                        }
                    } else {
                        // Case where profile.favoriteShops is nil
                        Text("No favorite shops added yet.")
                            .foregroundColor(.gray)
                    }
                } else {
                    // Case where authService.userProfile is nil
                    Text("Please log in to view your favorites.")
                        .foregroundColor(.gray)
                }
            }
        }
    }

    // Function to handle the deletion logic
    func deleteFavoriteShop(at offsets: IndexSet, in shops: inout [String]) {
        offsets.forEach { index in
            let shopIdToRemove = shops[index]

            firebaseManager.removeCafeFromFavorites(cafeId: shopIdToRemove) { result in
                switch result {
                case .success():
                    print("Successfully removed \(shopIdToRemove) from Firebase favorites.")
                    
                    if var currentFavoriteShops = authService.userProfile?.favoriteShops {
                        currentFavoriteShops.removeAll { $0 == shopIdToRemove }
                        authService.userProfile?.favoriteShops = currentFavoriteShops
                    }

                case .failure(let error):
                    print("Error removing \(shopIdToRemove) from Firebase favorites: \(error.localizedDescription)")
                    // Optionally, show an alert to the user
                }
            }
        }
        shops.remove(atOffsets: offsets)
        authService.userProfile?.favoriteShops = shops // Ensure authService reflects the change
    }
}
