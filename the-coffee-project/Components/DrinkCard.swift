//
//  DrinkCard.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct DrinkCard: View {
    var drink: Drink
    
    let drinkCardImageWidth: CGFloat = 180.0
    let drinkCardImageHeight: CGFloat = 160.0
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: drink.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: drinkCardImageWidth, height: drinkCardImageHeight)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: drinkCardImageWidth, height: drinkCardImageHeight)
                        .cornerRadius(12)
                        .clipped()
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit() // Use scaledToFit for system images
                        .frame(width: drinkCardImageWidth, height: drinkCardImageHeight)
                        .cornerRadius(12)
                        .foregroundColor(.gray)
                @unknown default:
                    // Handle potential future cases
                    EmptyView()
                }
            }
            
            Text(drink.name)
                .font(Font.custom("Crimson Pro Medium", size: 24))
                .padding(.top, 5)
                .lineLimit(1)
                .frame(width: 180, alignment: .leading)

            if !drink.description.isEmpty {
                Text(drink.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(width: 180, alignment: .leading)
            }
        }
    }
}
