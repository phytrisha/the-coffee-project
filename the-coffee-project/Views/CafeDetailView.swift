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
    @StateObject private var firebaseManager = FirebaseManager() // Instantiate your manager
    
    @State private var address: String = "Loading address..."
    @State private var isFavorite: Bool = false
    
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
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Toggle favorite status
                    toggleFavorite()
                } label: {
                    // Change icon based on isFavorite state
                    Label("Favorite", systemImage: isFavorite ? "heart.fill" : "heart")
                }
            }
        }
        // Fetch initial favorite status when the view appears
        .onAppear {
            checkIfFavorite()
        }
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
    
    // Function to toggle favorite status
    func toggleFavorite() {
        if isFavorite {
            // It's currently a favorite, so remove it
            guard let cafeId = cafe.id else { // Using dummyCafe.id for the example
                print("Error: Cafe ID is nil. Cannot add to favorites.")
                return
            }
            
            firebaseManager.removeCafeFromFavorites(cafeId: cafeId) { result in
                switch result {
                case .success():
                    self.isFavorite = false // Update UI state
                    print("Cafe removed from favorites!")
                case .failure(let error):
                    print("Error removing cafe from favorites: \(error.localizedDescription)")
                    // Show error to user
                }
            }
        } else {
            guard let cafeId = cafe.id else { // Using dummyCafe.id for the example
                print("Error: Cafe ID is nil. Cannot add to favorites.")
                return
            }
            // It's not a favorite, so add it
            firebaseManager.addCafeToFavorites(cafeId: cafeId) { result in
                switch result {
                case .success():
                    self.isFavorite = true // Update UI state
                    print("Cafe added to favorites!")
                case .failure(let error):
                    print("Error adding cafe to favorites: \(error.localizedDescription)")
                    // Show error to user
                }
            }
        }
    }

    // Function to check if the current cafe is already a favorite
    func checkIfFavorite() {
        guard let cafeId = cafe.id else { // If currentCafeId could be 'String?', use 'guard let cafeId = currentCafeId else'
            print("Error: Cafe ID is empty. Cannot check favorite status.")
            self.isFavorite = false // Assume not favorite if ID is invalid
            return
        }

        firebaseManager.fetchFavoriteCafeIds { result in
            switch result {
            case .success(let favoriteIds):
                // favoriteIds is [String], currentCafeId is String (after guard)
                self.isFavorite = favoriteIds.contains(cafeId)
                print("Cafe \(cafeId) is favorite: \(self.isFavorite)")
            case .failure(let error):
                print("Error checking favorite status: \(error.localizedDescription)")
                self.isFavorite = false
            }
        }
    }

}
