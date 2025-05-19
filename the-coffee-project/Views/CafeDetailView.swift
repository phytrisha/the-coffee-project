//
//  CafeDetailView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
struct CafeDetailView: View {
    let cafe: Cafe
    @StateObject var detailFetcher = CafeDetailFetcher()

    var featuredDrinks: [Drink] {
        Array(detailFetcher.drinks.prefix(3))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                // Featured Drinks Section
                if !featuredDrinks.isEmpty {
                    Text("Featured Drinks")
                        .font(Font.custom("Crimson Pro Medium", size: 28))
                        .padding(.top, 5)
                        .padding(.horizontal)
                        .lineLimit(1)
                        .frame(alignment: .leading)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(featuredDrinks) { drink in
                                NavigationLink(destination: DrinkDetailView(drink: drink)) {
                                    DrinkCard(drink: drink)
                                }
                                .buttonStyle(PlainButtonStyle()) // Optional: Remove default button styling
                            }
                        }
                        .padding(.horizontal)
                    }
                }

                // All Drinks Section
                if !detailFetcher.drinks.isEmpty {
                    Text("All Drinks")
                        .font(Font.custom("Crimson Pro Medium", size: 28))
                        .padding(.top, 5)
                        .padding(.horizontal)
                        .lineLimit(1)
                        .frame(alignment: .leading)

                    VStack(alignment: .leading) {
                        ForEach(detailFetcher.drinks) { drink in
                            NavigationLink(destination: DrinkDetailView(drink: drink)) {
                                DrinkListItem(drink: drink)
                            }
                            .buttonStyle(PlainButtonStyle()) // Optional: Remove default button styling
                        }
                    }
                } else {
                    ContentUnavailableView("Loading Drinks...", systemImage: "hourglass")
                        .padding()
                }
            }
        }
        .navigationTitle(cafe.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if detailFetcher.drinks.isEmpty { // Only fetch if drinks are not already loaded
                if let cafeId = cafe.id {
                    detailFetcher.fetchDrinks(forCafeId: cafeId)
                } else {
                    print("Error: Cafe ID is missing, cannot fetch drinks subcollection.")
                }
            }
        }
        // .onDisappear { detailFetcher.stopListening() } // Good practice to stop listener if needed
    }

}
