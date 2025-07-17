//
//  OrderButtonView.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 17.07.25.
//

import SwiftUI

struct OrderButtonView: View {
    @Binding var showingSheet: Bool
    
    var body: some View {
        Button(action: {
            showingSheet = true
        }) {
            Text("Order Drink")
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .font(Font.custom("Crimson Pro Medium", size: 20))
                .cornerRadius(12)
        }
        .padding([.horizontal, .bottom])
    }
}
