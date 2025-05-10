//
//  CafeCard.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct CafeCard: View {
    var cafe: Cafe

    var body: some View {
        VStack(alignment: .leading) {
            // Image loading using AsyncImage
            // Provide the URL from the cafe object
            AsyncImage(url: URL(string: cafe.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    // Placeholder while loading
                    ProgressView()
                        .frame(width: 200, height: 150) // Match desired image frame
                case .success(let image):
                    // Display the loaded image
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 150)
                        .cornerRadius(8)
                        .clipped()
                case .failure:
                    // Placeholder if image loading fails (e.g., broken URL)
                    Image(systemName: "photo.fill") // Use a system image placeholder
                        .resizable()
                        .scaledToFit() // Use scaledToFit for system images
                        .frame(width: 200, height: 150)
                        .cornerRadius(8)
                        .foregroundColor(.gray)
                @unknown default:
                    // Handle potential future cases
                    EmptyView()
                }
            }


            Text(cafe.name)
                .font(.headline)
                .padding(.top, 5)
            
            Text(cafe.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
                .frame(width: 200, alignment: .leading)

            // You could add the "5 min" overlay here using ZStack (outside the scope of this request)
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal, 5)
    }
}
