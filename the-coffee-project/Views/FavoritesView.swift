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
            VStack {
                Text("Favorites")
                    .font(Font.custom("Crimson Pro Medium", size: 28))
                    .padding(.leading)
                    .padding(.top)
                if let profile = authService.userProfile {
                    if let shops = profile.favoriteShops {
                        ForEach(shops, id: \.self) { item in
                            VStack(alignment: .leading) {
                                ForEach(fetcher.cafes) { cafe in
                                    if cafe.id == item {
                                        NavigationLink(destination: CafeDetailView(cafe: cafe)) {
                                            CafeListItem(cafe: cafe)
                                        }
                                        .buttonStyle(PlainButtonStyle()) // Optional: Remove default button styling
                                        .contentShape(Rectangle())
                                    }
                                }
                            }
                        }
                    } else {
                        Text("No favorite shops added yet.")
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
        }
    }
}
