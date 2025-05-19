//
//  LoginView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 19.05.25.
//

import SwiftUI
import FirebaseAuth // Make sure you have imported Firebase/Auth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String? = nil
    @Environment(\.presentationMode) var presentationMode // Optional: if you want to dismiss this view after login

    var body: some View {
        NavigationView { // Optional: for a title and potential navigation
            VStack {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .autocapitalization(.none) // Useful for emails
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 10)

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                Button("Login") {
                    login()
                }
                .padding(.top, 20)
                .buttonStyle(.plain) // Or any style you prefer

                Spacer()
            }
            .navigationTitle("Login") // Optional: for the NavigationView title
            .padding()
        }
    }

    func login() {
        errorMessage = nil // Clear previous errors

        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Handle specific Firebase Auth errors if needed
                errorMessage = error.localizedDescription
                print("Error logging in: \(error.localizedDescription)")
            } else {
                // Login successful
                print("User logged in successfully!")
                // You can navigate away or dismiss the view here
                // For example, if you are presenting this view modally:
                // presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
