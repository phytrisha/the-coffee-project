//
//  DrinkDetailView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 19.05.25.
//

import SwiftUI

struct DrinkDetailView: View {
    @EnvironmentObject var authService: AuthService
    
    var drink: Drink
    var cafe: Cafe
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack {
            DrinkHeaderView(drink: drink)
            
            Spacer()
            
            OrderButtonView(showingSheet: $showingSheet)
                .disabled(authService.userProfile?.userCredits ?? 0 == 0)
        }
        .sheet(isPresented: $showingSheet) {
            OrderConfirmationView(
                drink: drink,
                cafe: cafe,
                isPresented: $showingSheet
            )
            .environmentObject(authService)
        }
        .navigationTitle(drink.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
