//
//  OrderConfirmationView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 17.07.25.
//

import SwiftUI

struct OrderConfirmationView: View {
    @EnvironmentObject var authService: AuthService
    
    private var drink: Drink
    private var cafe: Cafe
    
    @Binding var isPresented: Bool
    
    init(drink: Drink, cafe: Cafe, isPresented: Binding<Bool>) {
        self.drink = drink
        self.cafe = cafe
        self._isPresented = isPresented
    }
    
    var body: some View {
        @StateObject var viewModel = OrderConfirmationViewModel(drink: drink, cafe: cafe, authService: authService)
        
        NavigationView {
            VStack {
                // ... Your Order Confirmation UI ...
                // You can further break this down if needed
                
                ConfirmationSlider(text: "Slide to confirm", action: {
                    viewModel.confirmOrder()
                })
            }
            .onAppear(perform: viewModel.fetchAddress)
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
