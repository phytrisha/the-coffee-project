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

    @Published var userLocation: CLLocationCoordinate2D?
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868), // Default region (e.g., somewhere in California)
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
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // Adjust span as needed
            )
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation() // Start updating location once authorized
        case .denied, .restricted:
            print("Location access denied or restricted.")
            // Handle denied or restricted access (e.g., show an alert)
        case .notDetermined:
            print("Location authorization not determined.")
            // This case is handled in init() by requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown authorization status.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
