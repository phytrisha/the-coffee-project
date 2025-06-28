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

                        VStack(alignment: .leading) {
                            ForEach(fetcher.cafes) { cafe in
                                NavigationLink(destination: CafeDetailView(cafe: cafe)) {
                                    CafeListItem(cafe: cafe)
                                }
                                .buttonStyle(PlainButtonStyle()) // Optional: Remove default button styling
                                .padding(.vertical, 8)
                            }
                        }
                    } else {
                        ContentUnavailableView("Loading Cafés...", systemImage: "hourglass")
                            .padding()
                    }
                }
            }
            .navigationTitle("Your Feed")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                Button {
                    showingScanner = true // Trigger the sheet presentation
                } label: {
                    Image(systemName: "qrcode.viewfinder") // SF Symbol for a QR code scanner icon
                        .font(.title2) // Adjust font size as needed
                }
            )
            .sheet(isPresented: $showingScanner) {
                // Present the QRCodeScannerView as a sheet
                QRCodeScannerView()
            }
        }
    }
}
