//
//  ThemedCornerRadius.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 30.06.25.
//

import SwiftUI

struct ThemedCornerRadius: ViewModifier {
    @EnvironmentObject var theme: AppTheme
    let size: CornerRadiusSize
    
    enum CornerRadiusSize { case small, medium, large }
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(radius)
    }
    
    private var radius: CGFloat {
        switch size {
        case .small: return theme.cornerRadii.small
        case .medium: return theme.cornerRadii.medium
        case .large: return theme.cornerRadii.large
        }
    }
}
