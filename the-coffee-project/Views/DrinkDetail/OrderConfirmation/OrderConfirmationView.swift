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
            VStack {
                // ... Your Order Confirmation UI ...
                // You can further break this down if needed
                
                ConfirmationSlider(text: "Slide to confirm", action: {
                    viewModel.confirmOrder()
                })
            }
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
            .navigationTitle("Thank You!")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}
