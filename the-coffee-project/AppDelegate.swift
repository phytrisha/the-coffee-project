//
//  AppDelegate.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import UIKit // Needed for UIApplicationDelegate
import FirebaseCore // Needed for FirebaseApp

// Define your custom AppDelegate class
class AppDelegate: NSObject, UIApplicationDelegate {

  // This function is called when the app finishes launching
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    // Initialize Firebase here!
    FirebaseApp.configure()
    print("Firebase has been configured!") // Optional: good for confirmation during setup

    // Return true to indicate successful app launch
    return true
  }

  // You can add other UIApplicationDelegate methods here later if needed,
  // e.g., for handling push notifications, background tasks, etc.

}
