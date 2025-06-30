//
//  ContentView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Feed", image: "Coffee Cup") {
                FeedView()
            }
            Tab("Explore", image: "Location") {
                ExploreView()
            }
            Tab("Search", image: "Search") {
                SearchView()
            }
            Tab("Favorites", image: "Favorite") {
                FavoritesView()
            }
            Tab("Profile", image: "User") {
                ProfileView()
            }
            
        }
    }
}
