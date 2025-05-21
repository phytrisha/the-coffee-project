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
                // Display custom User Profile info from Firestore
                if let profile = authService.userProfile {
                    AsyncImage(url: URL(string: profile.imageUrl ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 128, height: 128)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 128, height: 128)
                                .cornerRadius(999)
                                .clipped()
                                .padding(.horizontal)
                        case .failure:
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit() // Use scaledToFit for system images
                                .frame(width: 128, height: 128)
                                .cornerRadius(999)
                                .foregroundColor(.gray)
                                .padding(.horizontal)
                        @unknown default:
                            // Handle potential future cases
                            EmptyView()
                        }
                    }
                    
                    Text("\(profile.firstName ?? "None") \(profile.lastName ?? "None")")
                        .font(Font.custom("Crimson Pro Medium", size: 28))
                        .padding(.horizontal)
                        .padding(.top)
                        .frame(maxWidth: .infinity)
                    
                    Text("\(user.email ?? "N/A")")
                        .font(.subheadline)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray)
                    
                    Divider().padding(.vertical)
                    
                    Text("Credits: \(profile.userCredits?.description ?? "None")")
                        .font(Font.custom("Crimson Pro Medium", size: 20))
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                    
                } else {
                    Text("Fetching user profile...")
                        .foregroundColor(.gray)
                }
                
                Spacer()

                Button("Sign Out") {
                    authService.signOut()
                }
                .padding(12)
                .frame(width: 370, alignment: .center)
                .background(.red)
                .foregroundColor(.white)
                .font(Font.custom("Crimson Pro Medium", size: 20))
                .cornerRadius(12)
                .padding(.bottom, 16)

            } else {
                // This case should ideally not be reached if ContentView is only shown when isLoggedIn is true
                Text("User not logged in.")
            }
        }
        .navigationTitle("Profile")
        .padding()
    }
}
