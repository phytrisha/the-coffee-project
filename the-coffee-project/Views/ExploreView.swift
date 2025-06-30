//
//  ExploreView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
import MapKit
import CoreLocation

struct ExploreView: View {
    @StateObject var fetcher = CafeFetcher()
    @StateObject private var locationManager = LocationManager()


    
    @State private var selectedCafe: Cafe?
    @State private var cafeToNavigateTo: Cafe?


    var body: some View {
        NavigationStack{
            Map(coordinateRegion: $locationManager.region, showsUserLocation: true, annotationItems: fetcher.cafes) { cafe in
                // For each cafe, create a MapAnnotation
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(cafe.lat), longitude: CLLocationDegrees(cafe.long))) {
                    VStack {
                        Image("Pin") // A coffee cup icon
                            .frame(width: 32, height: 32)
                            .shadow(radius: 4)
                    }
                    .onTapGesture {
                        self.selectedCafe = cafe
                    }
                }
            }
            .ignoresSafeArea(.all)
            .sheet(item: $selectedCafe) { cafe in
                // Pass a binding to `cafeToNavigateTo` and the dismiss action to the sheet content
                CafeDetailSheet(cafe: cafe, cafeToNavigateTo: $cafeToNavigateTo) {
                    self.selectedCafe = nil // Dismiss the sheet
                }
                // Retain presentationDetents if targeting iOS 16+
                .presentationDetents([.medium, .large])
            }
            .navigationDestination(item: $cafeToNavigateTo) { cafe in
                 CafeDetailView(cafe: cafe)
            }
        }
    }
}

struct CafeDetailSheet: View {
    let cafe: Cafe
    
    @Binding var cafeToNavigateTo: Cafe?
    var dismissSheet: () -> Void
    
    @State private var address: String = "Loading address..."

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                if let imageUrl = cafe.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 64, height: 64)
                             .cornerRadius(999)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 64, height: 64)
                    }
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 64, height: 64)
                        .foregroundColor(.gray)
                        .cornerRadius(999)
                }
                
                Text(cafe.name)
                    .font(Font.custom("Crimson Pro Medium", size: 28))
                    .padding(.horizontal)
            }

            Text(cafe.description)
                .font(.body)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)

            HStack {
                Image(systemName: "map.fill")
                Text(address)
            }
            .font(.footnote)
            .foregroundColor(.gray)

            Spacer()
            
            Button {
                self.cafeToNavigateTo = cafe
                dismissSheet()
            } label: {
                Text("Visit Café")
                    .padding(12)
                    .frame(width: 370, alignment: .center)
                    .background(.accent)
                    .foregroundColor(.white)
                    .font(Font.custom("Crimson Pro Medium", size: 20))
                    .cornerRadius(12)
                    .padding(.bottom, 16)
            }
        }
        .padding()
        .presentationDetents([.medium, .large]) // iOS 16+ for half-sheet, full-sheet
        .onAppear {
            // Call the shared function
            reverseGeocode(latitude: cafe.lat, longitude: cafe.long) { resolvedAddress in
                self.address = resolvedAddress // Update the state variable with the result
            }
        }
    }
}
