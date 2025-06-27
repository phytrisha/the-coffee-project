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
            Tab("Feed", systemImage: "cup.and.saucer") {
                FeedView()
              }
            Tab("Explore", systemImage: "location") {
                ExploreView()
            }
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }
            Tab("Favorites", systemImage: "heart") {
                FavoritesView()
            }
            Tab("Profile", systemImage: "person.circle") {
                ProfileView()
            }
            
        }
    }
}
