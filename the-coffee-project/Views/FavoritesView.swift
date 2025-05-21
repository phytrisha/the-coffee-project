//
//  FavoritesView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
import FirebaseAuth

struct FavoritesView: View {
    @EnvironmentObject var authService: AuthService
    @StateObject var fetcher = CafeFetcher()
    
    var body: some View {
        NavigationView {
            if let profile = authService.userProfile {
                if let shops = profile.favoriteShops {
                    List {
                        ForEach(shops, id: \.self) { favoriteShopID in
                            // Find the corresponding cafe from the fetcher's cafes
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
                    }
                    .listStyle(.plain)
                    .navigationTitle("Favorites")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    Text("No favorite shops added yet.")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
