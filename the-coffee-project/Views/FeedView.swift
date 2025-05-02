//
//  FeedView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct FeedView: View {
    @StateObject var fetcher = CafeFetcher() // Your data fetcher

    var body: some View {
        // Wrap the entire content in a NavigationView
        NavigationView {
            VStack(alignment: .leading) {
                // MARK: - Top Area (Placeholder)
                // Keeping your custom header structure
                // TopHeaderView()

                // MARK: - Cafés Around You Section
                Text("Featured Cafés")
                    .font(.title2)
                    .padding(.leading)
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(fetcher.cafes) { cafe in
                            // Only show featured cafes
                            if cafe.featured ?? false { // Use nil coalescing for optional Bool
                                // Wrap the CafeCard in a NavigationLink
                                NavigationLink {
                                    // This is the DESTINATION view when the card is tapped
                                    CafeDetailView(cafe: cafe) // Navigate to CafeDetailView, passing the cafe
                                } label: {
                                    // This is the LABEL - the content that is displayed and tappable
                                    CafeCard(cafe: cafe) // Your existing CafeCard
                                        // Apply .foregroundColor(.primary) to prevent the default blue tint
                                        // applied by NavigationLink to its label content
                                        .foregroundColor(.primary)
                                }
                                // Remove the .buttonStyle(.plain) if you added it previously -
                                // the .foregroundColor(.primary) handles the styling
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // MARK: - Order Again Section
                Text("Order again")
                    .font(.title2)
                    .padding(.leading)
                    .padding(.top)

                // This section remains as is, assuming these cards are not
                // currently designed to navigate to a CafeDetailView
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(0..<5) { item in // Example: 5 placeholder cards
                            DrinkCard() // Assuming you have a DrinkCard view
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer() // Pushes content to the top

            } // End VStack
            // You can add a navigation title here if you want one for the FeedView
            // Note: This will appear in the standard navigation bar area.
            // If your TopHeaderView completely replaces the standard bar visually,
            // you might set the title to "" or hide the navigation bar for this view.
             .navigationTitle("Feed") // Example title
             .navigationBarTitleDisplayMode(.inline) // Optional: Smaller title
            // If you want to hide the default navigation bar entirely because
            // TopHeaderView replaces it:
            // .navigationBarHidden(true) // Note: navigationBarHidden is deprecated
            // A modern approach would involve customizing the toolbar instead.
        } // End NavigationView
         // The fetcher is likely initialized and fetching in its init()
         // .onAppear { fetcher.fetchCafes() } // If you prefer fetching on appear
    }
}

struct TopHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Good Morning, Mark.")
                    .font(.title)
                    .fontWeight(.semibold)
                // You could add a subtitle here if needed
            }
            Spacer()
            // Add icons here, e.g., profile picture, notification bell
            Image(systemName: "bell.fill") // Example bell icon
                .font(.title2)
                .padding(.trailing) // Add padding to the icon
            // Add profile image placeholder
        }
        .padding() // Add padding around the header content
    }
}
