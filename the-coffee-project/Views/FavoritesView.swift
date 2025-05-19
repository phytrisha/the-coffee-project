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
    
    var body: some View {
        VStack {
            Text("Favorites View")
                .font(.largeTitle)
            if let profile = authService.userProfile {
                if let shops = profile.favoriteShops {
                    ForEach(shops, id: \.self) { item in
                        Text(item)
                    }
                } else {
                    Text("No favorite shops added yet.")
                        .foregroundColor(.gray)
                }
            }
        }
    }
}
