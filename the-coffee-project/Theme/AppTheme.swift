//
//  AppTheme.swift
//  the-coffee-project
//
//  Created by Mark Meyer on 30.06.25.
//

import SwiftUI

final class AppTheme: ObservableObject {
    @Published var cornerRadii: CornerRadii = .default

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
}
