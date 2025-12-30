import SwiftUI

enum Theme {

    enum Colors {
        static let wine = Color("Wine")
        static let wineDark = Color("WineDark")
        static let cream = Color("Cream")
        static let charcoal = Color("Charcoal")
        static let card = Color("Card")
        static let divider = Color("Divider")
        static let textPrimary = Color("TextPrimary")
        static let textSecondary = Color("TextSecondary")
    }

    enum Radius {
        static let card: CGFloat = 24
        static let button: CGFloat = 18
        static let chip: CGFloat = 14
    }

    enum Spacing {
        static let xs: CGFloat = 6
        static let sm: CGFloat = 10
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
    }
}
