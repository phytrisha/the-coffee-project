//
//  AuthService.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 19.05.25.
//
import Foundation
import FirebaseAuth
import FirebaseFirestore // Import Firestore
import Combine

class AuthService: ObservableObject {
    @Published var isLoggedIn: Bool
    @Published var currentUser: User?
    // Add a published property for the user's profile data
    @Published var userProfile: UserProfile?

    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    private var userProfileListener: ListenerRegistration? // To manage the Firestore listener

    init() {
        let initialUser = Auth.auth().currentUser
        self.isLoggedIn = initialUser != nil
        self.currentUser = initialUser
        // Attempt to fetch the profile immediately if a user is logged in on startup
        if initialUser != nil {
            startListeningForUserProfile(uid: initialUser!.uid)
        }

        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else {
                print("AuthService instance was deallocated.")
                return
            }

            self.isLoggedIn = user != nil
            self.currentUser = user

            if let uid = user?.uid {
                // User logged in or app started with logged-in user
                print("Auth state changed. User logged in with UID: \(uid)")
                self.startListeningForUserProfile(uid: uid) // Start listening for profile data
            } else {
                // User logged out
                print("Auth state changed. User logged out.")
                self.stopListeningForUserProfile() // Stop listening for profile data
                self.userProfile = nil // Clear the profile data
            }
        }
    }

    deinit {
        if let handle = authStateDidChangeListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        self.stopListeningForUserProfile() // Stop Firestore listener on deinit
        print("AuthService deinitialized.")
    }

    // Function to start listening for real-time changes to the user profile document
    private func startListeningForUserProfile(uid: String) {
        // Stop any existing listener first
        stopListeningForUserProfile()

        // Create a reference to the user's document in the "users" collection
        let userDocumentRef = Firestore.firestore().collection("users").document(uid)

        // Add a real-time listener
        userProfileListener = userDocumentRef.addSnapshotListener { [weak self] documentSnapshot, error in
            guard let self = self else {
                print("AuthService instance deallocated while listening to profile.")
                return
            }

            if let error = error {
                print("Error fetching user profile: \(error.localizedDescription)")
                self.userProfile = nil // Clear profile on error
                return
            }

            guard let document = documentSnapshot else {
                print("User profile document snapshot is nil.")
                self.userProfile = nil // Clear profile if document is nil
                return
            }

            // Attempt to decode the document into a UserProfile struct
            do {
                self.userProfile = try document.data(as: UserProfile.self)
                print("User profile fetched/updated: \(self.userProfile?.firstName ?? "N/A")") // Optional: for debugging
            } catch {
                print("Error decoding user profile: \(error.localizedDescription)")
                self.userProfile = nil // Clear profile on decoding error
            }
        }
    }

    // Function to stop the Firestore listener
    private func stopListeningForUserProfile() {
        userProfileListener?.remove()
        userProfileListener = nil
        print("Stopped listening for user profile.") // Optional: for debugging
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            // The authStateDidChangeListener will handle setting isLoggedIn=false and userProfile=nil
            print("User signed out.")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    // Example login function (can stay here or in LoginView)
     func signIn(email: String, password: String, completion: @escaping (Error?) -> Void) {
         Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
             // The authStateDidChangeListener will handle updating state and fetching profile
             completion(error) // Pass the error back to the caller
         }
     }
}
