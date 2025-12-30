import Foundation

enum WineType: String, CaseIterable, Codable {
    case red, white, rose, sparkling, dessert, fortified

    var displayName: String {
        switch self {
        case .red: return "Red"
        case .white: return "White"
        case .rose: return "Rosé"
        case .sparkling: return "Sparkling"
        case .dessert: return "Dessert"
        case .fortified: return "Fortified"
        }
    }
}
