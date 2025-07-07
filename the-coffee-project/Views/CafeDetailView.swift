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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // MARK: Cafe Background Image
                GeometryReader { geometry in
                    AsyncImage(url: URL(string: cafe.backgroundImageUrl ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: geometry.size.width, height: 240)
                        case .success(let image):
                            if #available(iOS 26.0, *) {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: 240)
                                    .backgroundExtensionEffect()
                                    .clipped()
                            } else {
                                // Fallback on earlier versions
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: 240)
                                    .clipped()
                            }
                        case .failure:
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit() // Use scaledToFit for system images
                                .frame(width: geometry.size.width, height: 240)
                                .foregroundColor(.gray)
                        @unknown default:
                            // Handle potential future cases
                            EmptyView()
                        }
                    }
                }
                .frame(height: 240)
                
                // MARK: Cafe Header
                HStack {
                    if let imageUrl = cafe.imageUrl, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(width: 96, height: 96)
                                 .clipShape(Circle()) // Clips the image to have rounded corners
                                 .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                                 .overlay(
                                     Circle() // Defines the shape of the overlay
                                         .stroke(Color.white, lineWidth: 4) // Strokes the shape to create the border
                                 )
                        } placeholder: {
                            ProgressView()
                                .frame(width: 96, height: 96)
                                .clipShape(Circle()) // Clips the image to have rounded corners
                                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
                                .overlay(
                                    Circle() // Defines the shape of the overlay
                                        .stroke(Color.white, lineWidth: 4) // Strokes the shape to create the border
                                )
                        }
                    } else {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 96, height: 96)
                            .foregroundColor(.gray)
                            .cornerRadius(999)
                    }
                    VStack (alignment: .leading) {
                        Text(cafe.name)
                            .font(Font.custom("Crimson Pro Medium", size: 28))
                            .lineLimit(1)
                        Text(address)
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 8)
                }
                .padding(.horizontal)
                .padding(.top, -16)

                Text(cafe.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 8)
                    .padding(.horizontal)
                    .fixedSize(horizontal: false, vertical: true)
                
                Divider()
                    .padding(.horizontal)
                    .padding(.top, 8)
                
                // MARK: Featured Drinks Section
                Text("Featured Drinks")
                    .font(Font.custom("Crimson Pro Medium", size: 28))
                    .padding(.top, 16)
                    .padding(.horizontal)
                    .lineLimit(1)
                    .frame(alignment: .leading)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(detailFetcher.drinks) { drink in
                            if drink.featured {
                                NavigationLink(destination: DrinkDetailView(drink: drink, cafe: cafe)) {
                                    DrinkCard(drink: drink)
                                }
                                .buttonStyle(PlainButtonStyle()) // Optional: Remove default button styling
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }

                // MARK: All Drinks Section
                if !detailFetcher.drinks.isEmpty {
                    Text("All Drinks")
                        .font(Font.custom("Crimson Pro Medium", size: 28))
                        .padding(.horizontal)
                        .lineLimit(1)
                        .frame(alignment: .leading)

                    VStack(alignment: .leading) {
                        ForEach(detailFetcher.drinks) { drink in
                            NavigationLink(destination: DrinkDetailView(drink: drink, cafe: cafe)) {
                                DrinkListItem(drink: drink)
                            }
                            .buttonStyle(PlainButtonStyle()) // Optional: Remove default button styling
                            .padding(.vertical, 8)
                        }
                    }
                } else {
                    ContentUnavailableView("Loading Drinks...", systemImage: "hourglass")
                        .padding()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .ignoresSafeArea(.all, edges: [.top])
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
    
    // MARK: Toggle Favorite
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

    // MARK: Check if Favorite
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
