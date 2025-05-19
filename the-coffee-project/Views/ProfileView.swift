//
//  ProfileView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 02.05.25.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var authService: AuthService

    var body: some View {
        VStack {
            if let user = authService.currentUser {
                Text("Logged in as:")
                    .font(.headline)
                Text("Email: \(user.email ?? "N/A")")
                Text("User ID: \(user.uid)")

                Divider().padding(.vertical)

                // Display custom User Profile info from Firestore
                if let profile = authService.userProfile {
                    Text("Profile Details:")
                        .font(.headline)
                    Text("First Name: \(profile.firstName ?? "None")")
                    Text("Last Name: \(profile.lastName ?? "None")")
                    Text("Credits: \(profile.userCredits?.description ?? "None")")
                } else {
                    Text("Fetching user profile...")
                        .foregroundColor(.gray)
                }

                Button("Sign Out") {
                    authService.signOut()
                }
                .padding(.top, 20)
                .buttonStyle(.bordered)

            } else {
                // This case should ideally not be reached if ContentView is only shown when isLoggedIn is true
                Text("User not logged in.")
            }

            Spacer()
        }
        .navigationTitle("Profile")
        .padding()
    }
}
