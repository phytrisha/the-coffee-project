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
            FeedView()
                .tabItem {
                    Image("Coffee Cup")
                }

            ExploreView()
                .tabItem {
                    Image("Location")
                    
                }

            SearchView()
                .tabItem {
                    Image("Search")
                }
            
            FavoritesView()
                .tabItem {
                    Image("Favorite")
                }
            
            ProfileView()
                .tabItem {
                    Image("User")
                }
        }
    }
}
