//
//  OrderConfirmationView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 17.07.25.
//

import SwiftUI

struct OrderConfirmationView: View {
    @ObservedObject var viewModel: OrderConfirmationViewModel
    @Binding var isPresented: Bool

    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - View 1: The Scanner
                QRCodeScannerView { result in
                    switch result {
                    case .success(let code):
                        // Call the async function from within a Task
                        Task {
                            await viewModel.confirmOrder(with: code)
                        }
                    case .failure(let error):
                        // Handle scanning errors
                        print("Error")
                        // viewModel.presentAlert(with: .init(
                        //    title: Text("Scanning Error"),
                        //    message: Text(error.localizedDescription),
                        //    dismissButtonText: Text("OK") // Changed "OK" to Text("OK")
                        //))
                    }
                }
                .edgesIgnoringSafeArea(.all) // Modifier for the scanner

                // MARK: - View 2: The Overlay
                VStack {
                    Spacer()

                    Text("Point the camera at the store's QR code to confirm.")
                        .font(.headline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 60)
                }
                
            } // End of ZStack
            .alert(item: $viewModel.alertItem) { alertItem in
                Alert(
                    title: alertItem.title,
                    message: alertItem.message,
                    dismissButton: .default(alertItem.dismissButtonText) {
                        if viewModel.orderSuccessfullyPlaced {
                            isPresented = false
                        }
                    }
                )
            }
            .navigationTitle("Confirm Order")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.6)))
                    }
                }
            }
        } // End of NavigationView
    }
}
