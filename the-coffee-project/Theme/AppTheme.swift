//
//  AppTheme.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 30.06.25.
//

import SwiftUI

final class AppTheme: ObservableObject {
    @Published var cornerRadii: CornerRadii = .default
    @Published var headingStyle: TextStyle = .heading

    struct CornerRadii {
        let small: CGFloat
        let medium: CGFloat
        let large: CGFloat
        
        static let `default` = CornerRadii(
            small: 8,
            medium: 16,
            large: 24
        )
    }
    
    struct TextStyle {
        let fontName: String
        let fontSize: CGFloat
        let topPadding: CGFloat
        let lineLimit: Int?
        let frameWidth: CGFloat?
        
        static let heading = TextStyle(
            fontName: "Crimson Pro Medium",
            fontSize: 28,
            topPadding: 5,
            lineLimit: 1,
            frameWidth: 180
        )
    }
}
