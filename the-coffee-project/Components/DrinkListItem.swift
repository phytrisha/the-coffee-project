//
//  DrinkListItem.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 19.05.25.
//

import SwiftUI

struct DrinkListItem: View {
    var drink: Drink
    
    let drinkListItemImageWidth: CGFloat = 64.0
    let drinkListItemImageHeight: CGFloat = 64.0
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: drink.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: drinkListItemImageWidth, height: drinkListItemImageHeight)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: drinkListItemImageWidth, height: drinkListItemImageHeight)
                        .cornerRadius(999)
                        .clipped()
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit() // Use scaledToFit for system images
                        .frame(width: drinkListItemImageWidth, height: drinkListItemImageHeight)
                        .cornerRadius(999)
                        .foregroundColor(.gray)
                @unknown default:
                    // Handle potential future cases
                    EmptyView()
                }
            }
            VStack(alignment: .leading) {
                Text(drink.name)
                    .font(Font.custom("Crimson Pro Medium", size: 20))
                    .padding(.top, 5)
                    .lineLimit(1)
                    .frame(width: 180, alignment: .leading)

                if !drink.description.isEmpty {
                    Text(drink.description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}
