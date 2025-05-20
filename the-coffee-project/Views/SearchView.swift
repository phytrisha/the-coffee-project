//
//  SearchView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
import FirebaseFirestore // Make sure you import FirebaseFirestore if not already

struct SearchView: View {
    @StateObject var cafeFetcher = CafeFetcher() // Observe changes from CafeFetcher
    @State private var searchText = "" // State to hold the search bar text

    var filteredCafes: [Cafe] {
        if searchText.isEmpty {
            return cafeFetcher.cafes // If search text is empty, show all cafes
        } else {
            return cafeFetcher.cafes.filter { cafe in
                cafe.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationView { // Embed in NavigationView for the searchable modifier
            List(filteredCafes) { cafe in
                NavigationLink(destination: CafeDetailView(cafe: cafe)) {
                    CafeListItem(cafe: cafe)
                }
                .buttonStyle(PlainButtonStyle()) // Optional: Remove default button styling
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                .contentShape(Rectangle()) // <--- Make the entire row area tappable if it becomes a NavigationLink
                .padding(.vertical, 8)
            }
            .listStyle(.plain)
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search for cafes") // The search bar!
            .onAppear {
                // You might want to fetch cafes when the view appears,
                // although @StateObject for CafeFetcher will do it on init
                cafeFetcher.fetchCafes()
            }
        }
    }
}
