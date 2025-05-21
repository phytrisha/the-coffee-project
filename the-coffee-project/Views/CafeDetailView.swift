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
    
    @State private var address: String = "Loading address..."

    var featuredDrinks: [Drink] {
        Array(detailFetcher.drinks.prefix(3))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Cafe Details
                HStack {
                    if let imageUrl = cafe.imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(width: 64, height: 64)
                                 .cornerRadius(999)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 64, height: 64)
                        }
                    } else {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 64, height: 64)
                            .foregroundColor(.gray)
                            .cornerRadius(999)
                    }
                    
                    Text(cafe.name)
                        .font(Font.custom("Crimson Pro Medium", size: 28))
                }
                .padding(.horizontal)

                Text(cafe.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 10)
                    .padding(.horizontal)

                HStack {
                    Image(systemName: "map.fill")
                    Text(address)
                }
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.horizontal)
                
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
                                NavigationLink(destination: DrinkDetailView(drink: drink, cafe: cafe)) {
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
                            NavigationLink(destination: DrinkDetailView(drink: drink, cafe: cafe)) {
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
            reverseGeocode(latitude: cafe.lat, longitude: cafe.long) { resolvedAddress in
                self.address = resolvedAddress // Update the state variable with the result
            }
        }
        // .onDisappear { detailFetcher.stopListening() } // Good practice to stop listener if needed
    }

}
