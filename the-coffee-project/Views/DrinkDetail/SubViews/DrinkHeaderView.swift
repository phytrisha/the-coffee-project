//
//  DrinkHeaderView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 17.07.25.
//

import SwiftUI

struct DrinkHeaderView: View {
    let drink: Drink
    
    private let drinkImageSize: CGFloat = 128.0
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: drink.imageUrl ?? "")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: drinkImageSize, height: drinkImageSize)
            .clipShape(Circle())
            .padding(.top)
            
            Text(drink.name)
                .font(Font.custom("Crimson Pro Medium", size: 28))
                .padding(.top)
            
            Text(drink.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineLimit(4)
        }
        .padding(.horizontal)
    }
}
