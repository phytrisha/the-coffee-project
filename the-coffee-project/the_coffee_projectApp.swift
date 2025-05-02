//
//  the_coffee_projectApp.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
import FirebaseCore // Import FirebaseCore

// 1. Create a class that conforms to UIApplicationDelegate
// We use NSObject as UIResponder (the parent of AppDelegate) inherits from NSObject
class AppDelegate: NSObject, UIApplicationDelegate {
  // 2. Implement the didFinishLaunchingWithOptions method
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    // 3. Call FirebaseApp.configure() here
    print("Configuring Firebase...") // Optional: Add a print statement to confirm it runs
    FirebaseApp.configure()
    print("Firebase configured!") // Optional: Add a print statement

    // Return true to indicate successful application launch
    return true
  }

    // If you need other AppDelegate methods later (like handling push notifications),
    // you would implement them in this same class.
}

@main
struct the_coffee_projectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
