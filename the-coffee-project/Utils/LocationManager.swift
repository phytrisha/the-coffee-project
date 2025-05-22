//
//  LocationManager.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 22.05.25.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var hasCenteredMap = false // New flag to track if the map has been centered

    @Published var userLocation: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868), // Default region
        span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
    )

    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest // Set desired accuracy
        self.locationManager.requestWhenInUseAuthorization() // Request authorization when the app is in use
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        // Only center the map if it hasn't been centered yet
        if !hasCenteredMap {
            DispatchQueue.main.async {
                self.userLocation = location.coordinate
                self.region = MKCoordinateRegion(
                    center: location.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // A slightly tighter zoom for initial center
                )
                self.hasCenteredMap = true // Set the flag to true after centering
                self.locationManager.stopUpdatingLocation() // Stop updating location to prevent further centering
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // Only start updating if we haven't centered the map yet
            // Or if you want to allow re-centering if user closes and reopens the app
            if !hasCenteredMap {
                locationManager.startUpdatingLocation()
            }
        case .denied, .restricted:
            print("Location access denied or restricted.")
            // Handle denied or restricted access
        case .notDetermined:
            print("Location authorization not determined.")
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
    
    // Optional: Add a method to reset the centering if needed (e.g., if the user explicitly requests to re-center)
    func resetCentering() {
        hasCenteredMap = false
        locationManager.startUpdatingLocation() // Restart updating to get a new initial center
    }
}
