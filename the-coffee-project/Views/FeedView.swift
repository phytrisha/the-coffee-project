//
//  FeedView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI

struct FeedView: View {
    @StateObject var fetcher = CafeFetcher()
    @StateObject var orderStore = OrderStore()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                // MARK: - Top Area (Placeholder)
                // Custom header structure -> to do
                // TopHeaderView()

                Text("Featured Cafés")
                    .font(Font.custom("Crimson Pro Medium", size: 28))
                    .padding(.leading)
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(fetcher.cafes) { cafe in
                            if cafe.featured == true {
                                NavigationLink {
                                    CafeDetailView(cafe: cafe) // Navigate to CafeDetailView, passing the cafe
                                } label: {
                                    CafeCard(cafe: cafe)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // MARK: - Order Again Section
                Text("Order again")
                    .font(Font.custom("Crimson Pro Medium", size: 28))
                    .padding(.leading)
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(orderStore.latestOrders) { order in
                            // Pass the 'drink' object from the 'order' to the 'DrinkCard'
                            DrinkCard(drink: order.items[0])
                        }
                    }
                    .padding(.horizontal)
                }
                if orderStore.latestOrders.isEmpty {
                    Text("No recent orders found.")
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()

            }
            .navigationTitle("Good Morning, Mark")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct TopHeaderView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Good Morning, Mark.")
                    .font(.title)
                    .fontWeight(.semibold)
            }
            Spacer()
            Image(systemName: "bell.fill")
                .font(.title2)
                .padding(.trailing)
        }
        .padding()
    }
}
