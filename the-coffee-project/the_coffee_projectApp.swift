//
//  the_coffee_projectApp.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
import FirebaseCore

@main
struct the_coffee_projectApp: App {
    @StateObject var authService = AuthService()
    @StateObject var theme = AppTheme()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authService.isLoggedIn {
                ContentView()
                    .environmentObject(authService)
                    .environmentObject(theme)
            } else {
                LoginView()
                    .environmentObject(authService)
                    .environmentObject(theme)
            }
        }
    }
}
