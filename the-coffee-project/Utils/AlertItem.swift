//
//  AlertItem.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 17.07.25.
//

import SwiftUI

// Defines the structure for all alerts in the app.
struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButtonText: Text
}

// A central repository for predefined AlertItem instances.
struct AlertContext {
    // Alert for when the scanned QR code does not match the store ID.
    static let invalidQRCode = AlertItem(
        title: Text("Incorrect QR Code"),
        message: Text("The scanned QR code does not match this store. Please scan the correct code."),
        dismissButtonText: Text("Try Again")
    )
    
    static let invalidUserData = AlertItem(
        title: Text("Invalid User Data"),
        message: Text("There was a problem with your user information. Please try restarting the app."),
        dismissButtonText: Text("OK")
    )
    
    static func orderSuccess(drinkName: String, cafeName: String) -> AlertItem {
        AlertItem(
            title: Text("Order Confirmed! 🎉"),
            message: Text("Your \(drinkName) from \(cafeName) is being prepared."),
            dismissButtonText: Text("Great!")
        )
    }
    
    static let orderFailure = AlertItem(
        title: Text("Order Failed"),
        message: Text("We couldn't place your order due to an unexpected error. Please try again."),
        dismissButtonText: Text("OK")
    )
}
