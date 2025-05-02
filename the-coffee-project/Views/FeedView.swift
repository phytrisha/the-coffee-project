//
//  FeedView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        // Using a NavigationView to potentially handle a title,
        // though the image shows a custom top area.
        // For simplicity, we'll create a custom top area structure.
        VStack(alignment: .leading) {
            // MARK: - Top Area (Placeholder)
            // In a real app, this would likely be a custom view or part of a NavigationView setup
            TopHeaderView() // A placeholder for the top section

            // MARK: - Cafés Around You Section
            Text("Cafés around you")
                .font(.title2)
                .padding(.leading) // Add some padding to align with the image
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) { // Add spacing between cards
                    // Replace with actual data later
                    ForEach(0..<5) { item in // Example: 5 placeholder cards
                        CafeCard()
                    }
                }
                .padding(.horizontal) // Add horizontal padding to the ScrollView content
            }

            // MARK: - Order Again Section
            Text("Order again")
                .font(.title2)
                .padding(.leading) // Add some padding to align with the image
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) { // Add spacing between cards
                    // Replace with actual data later
                    ForEach(0..<5) { item in // Example: 5 placeholder cards
                        DrinkCard()
                    }
                }
                .padding(.horizontal) // Add horizontal padding to the ScrollView content
            }

            Spacer() // Pushes content to the top

        }
        // You might want to adjust the background color of the VStack
        // to match the image if it's not the default system background.
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
