//
//  DrinkCard.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct DrinkCard: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Placeholder Image
            Image("drink-placeholder") // Use an asset name or system image
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150) // Adjust size as needed
                .cornerRadius(8) // Rounded corners for the image
                .clipped() // Ensures the image respects the frame and corner radius

            Text("Drink Name")
                .font(.headline)
                .padding(.top, 5)

            Text("Description text of drink with a maximum of two l...")
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
                .frame(width: 150, alignment: .leading)
        }
        .background(Color.white)
        .cornerRadius(10)
    }
}
