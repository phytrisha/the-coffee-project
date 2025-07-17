//
//  DrinkDetailView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 19.05.25.
//

import SwiftUI

struct DrinkDetailView: View {
    var drink: Drink
    var cafe: Cafe
    @StateObject private var orderConfirmationViewModel: OrderConfirmationViewModel
    
    @State private var showingSheet = false
    
    init(drink: Drink, cafe: Cafe, authService: AuthService) {
        self.drink = drink
        self.cafe = cafe
        _orderConfirmationViewModel = StateObject(wrappedValue: OrderConfirmationViewModel(drink: drink, cafe: cafe, authService: authService))
    }
    
    var body: some View {
        VStack {
            DrinkHeaderView(drink: drink)
            
            Spacer()
            
            OrderButtonView(showingSheet: $showingSheet)
                .disabled(orderConfirmationViewModel.userCredits == 0)
        }
        .sheet(isPresented: $showingSheet) {
            OrderConfirmationView(
                viewModel: orderConfirmationViewModel,
                isPresented: $showingSheet
            )
        }
        .navigationTitle(drink.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

