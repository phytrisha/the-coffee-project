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
    
    @State private var showingScanner = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // MARK: - Featured Cafes
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
                        .padding(.top, 32)

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
                    
                    // MARK: - All Cafes Section
                    if !fetcher.cafes.isEmpty {
                        Text("All Cafés")
                            .font(Font.custom("Crimson Pro Medium", size: 28))
                            .padding(.leading)
                            .padding(.top, 32)
                            .lineLimit(1)
                            .frame(alignment: .leading)

                        // Refactored to List
                        List {
                            ForEach(fetcher.cafes) { cafe in
                                NavigationLink(destination: CafeDetailView(cafe: cafe)) {
                                    CafeListItem(cafe: cafe)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 16))
                                .contentShape(Rectangle())
                                .padding(.vertical, 8)
                            }
                        }
                        .listStyle(.plain)
                        .scrollDisabled(true)
                        .frame(height: CGFloat(fetcher.cafes.count) * 80)
                    } else {
                        ContentUnavailableView("Loading Cafés...", systemImage: "hourglass")
                            .padding()
                    }
                }
            }
            .navigationTitle("Your Feed")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
