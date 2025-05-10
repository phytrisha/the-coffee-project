//
//  CafeCard.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct CafeCard: View {
    var cafe: Cafe
    
    let coffeeCardImageWidth: CGFloat = 180.0
    let coffeeCardImageHeight: CGFloat = 160.0

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: cafe.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: coffeeCardImageWidth, height: coffeeCardImageHeight)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: coffeeCardImageWidth, height: coffeeCardImageHeight)
                        .cornerRadius(12)
                        .clipped()
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit() // Use scaledToFit for system images
                        .frame(width: coffeeCardImageWidth, height: coffeeCardImageHeight)
                        .cornerRadius(12)
                        .foregroundColor(.gray)
                @unknown default:
                    // Handle potential future cases
                    EmptyView()
                }
            }


            Text(cafe.name)
                .font(Font.custom("Crimson Pro Medium", size: 28))
                .padding(.top, 5)
                .lineLimit(1)
                .frame(width: 180, alignment: .leading)
            
            Text(cafe.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .frame(width: 180, alignment: .leading)

        }
    }
}
