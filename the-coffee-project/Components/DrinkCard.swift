//
//  DrinkCard.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct DrinkCard: View {
    
    let drinkCardImageWidth: CGFloat = 180.0
    let drinkCardImageHeight: CGFloat = 160.0
    
    var body: some View {
        VStack(alignment: .leading) {
            // Placeholder Image
            Image("Drink-Placeholder") // Use an asset name or system image
                .resizable()
                .scaledToFill()
                .frame(width: drinkCardImageWidth, height: drinkCardImageHeight) // Adjust size as needed
                .cornerRadius(12) // Rounded corners for the image
                .clipped() // Ensures the image respects the frame and corner radius

            Text("Drink Name")
                .font(Font.custom("Crimson Pro Medium", size: 24))
                .padding(.top, 5)
                .lineLimit(1)
                .frame(width: 180, alignment: .leading)

            Text("Description text of drink with a maximum of two lines so that it doesn't get too long.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 180, alignment: .leading)
        }
    }
}
