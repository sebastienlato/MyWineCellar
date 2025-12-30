import SwiftUI
import Combine


enum AppTab: Hashable {
    case home
    case library
    case add
    case stats
}

enum LibraryFilter: String, CaseIterable {
    case all
    case cellar
    case wishlist

    var title: String {
        switch self {
        case .all:
            return "All"
        case .cellar:
            return "Cellar"
        case .wishlist:
            return "Wishlist"
        }
    }
}

final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var libraryFilter: LibraryFilter = .all
}
