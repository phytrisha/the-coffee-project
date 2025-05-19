//
//  CafeListItem.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 19.05.25.
//

import SwiftUI

struct CafeListItem: View {
    var cafe: Cafe
    
    let cafeListItemImageWidth: CGFloat = 64.0
    let cafeListItemImageHeight: CGFloat = 64.0
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: cafe.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: cafeListItemImageWidth, height: cafeListItemImageWidth)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: cafeListItemImageWidth, height: cafeListItemImageWidth)
                        .cornerRadius(999)
                        .clipped()
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit() // Use scaledToFit for system images
                        .frame(width: cafeListItemImageWidth, height: cafeListItemImageWidth)
                        .cornerRadius(999)
                        .foregroundColor(.gray)
                @unknown default:
                    // Handle potential future cases
                    EmptyView()
                }
            }
            VStack(alignment: .leading) {
                Text(cafe.name)
                    .font(Font.custom("Crimson Pro Medium", size: 20))
                    .padding(.top, 5)
                    .lineLimit(1)
                    .frame(width: 180, alignment: .leading)

                if !cafe.description.isEmpty {
                    Text(cafe.description)
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
