//
//  LocationGeocoder.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 21.05.25.
//

import Foundation
import CoreLocation

// Define a completion handler type for convenience
typealias AddressCompletionHandler = (String) -> Void

/// Performs reverse geocoding to convert coordinates to a readable address string.
/// - Parameters:
///   - latitude: The latitude of the location.
///   - longitude: The longitude of the location.
///   - completion: A closure that is called with the formatted address string.
func reverseGeocode(latitude: Float, longitude: Float, completion: @escaping AddressCompletionHandler) {
    let geocoder = CLGeocoder()
    let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))

    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        // Ensure this closure runs on the main thread as it will update UI indirectly
        DispatchQueue.main.async {
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                completion("Address not found")
                return
            }

            guard let placemark = placemarks?.first else {
                completion("No placemark found")
                return
            }

            let addressComponents = [
                placemark.thoroughfare,      // Street name
                placemark.subThoroughfare,   // Street number
                placemark.locality,          // City
//                placemark.administrativeArea, // State/Province
//                placemark.postalCode,        // Postal code
//                placemark.country            // Country
            ].compactMap { $0 }
            
            var formattedAddress = addressComponents[0] + " " + addressComponents[1] + ", " + addressComponents[2]

            if formattedAddress.isEmpty {
                formattedAddress = "Address not available"
            }
            
            completion(formattedAddress)
        }
    }
}
