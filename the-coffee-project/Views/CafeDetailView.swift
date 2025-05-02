//
//  CafeDetailView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct CafeDetailView: View {
    let cafe: Cafe // Still receive the parent Cafe object
    @StateObject var detailFetcher = CafeDetailFetcher() // Instantiate the new fetcher

    var body: some View {
        VStack {
            // You can still display parent cafe details here
            // Text(cafe.description ?? "No description available.")
            // AsyncImage for cafe image... etc.

            // Display the list of drinks from the detailFetcher
            if !detailFetcher.drinks.isEmpty {
                List {
                    Section("Menu") {
                        // Iterate over the drinks fetched by detailFetcher
                        ForEach(detailFetcher.drinks) { drink in
                            // Display properties from the Drink object
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(drink.name)
                                        .font(.headline)
                                    // Check if the non-optional description is not empty
                                    if !drink.description.isEmpty {
                                        Text(drink.description)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer()
                                Text("$\(drink.price, specifier: "%.2f")")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            } else {
                // Show loading indicator or message while fetching, or if no drinks found
                ContentUnavailableView("Loading Drinks...", systemImage: "hourglass")
                    // Check if fetching is complete and list is still empty
                    // if detailFetcher.isLoading == false { Text("No Drinks Listed") }
            }
        }
        .navigationTitle(cafe.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Trigger the fetch for drinks using the cafe's ID when the view appears
            if let cafeId = cafe.id {
                detailFetcher.fetchDrinks(forCafeId: cafeId)
            } else {
                print("Error: Cafe ID is missing, cannot fetch drinks subcollection.")
                // Potentially update UI to show an error state
            }
        }
        // .onDisappear { detailFetcher.stopListening() } // Good practice to stop listener if needed
    }
}
