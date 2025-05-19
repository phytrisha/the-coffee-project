//
//  the_coffee_projectApp.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
import FirebaseCore // Make sure FirebaseCore or Firebase is imported

@main
struct the_coffee_projectApp: App { // Replace with your actual App struct name
    // Use @StateObject to create and manage the lifecycle of AuthService
    @StateObject var authService = AuthService()

    init() {
        FirebaseApp.configure() // Ensure this is called once
        // The auth state listener logic is now inside AuthService, so remove it from here.
    }

    var body: some Scene {
        WindowGroup {
            // Observe authService.isLoggedIn to switch views
            if authService.isLoggedIn {
                ContentView() // Your main content view
                    .environmentObject(authService)
            } else {
                LoginView() // Show the login view
                    .environmentObject(authService)
            }
        }
    }
}
