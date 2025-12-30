import Foundation
import SwiftData

@Model
final class Tasting {
    @Attribute(.unique) var id: UUID
    var date: Date
    var rating: Double

    // SwiftData-friendly for now (format later)
    var pricePaid: Double?

    var location: String?
    var memo: String?

    // Inverse relationship is defined on Wine.tastings
    var wine: Wine?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        rating: Double,
        pricePaid: Double? = nil,
        location: String? = nil,
        memo: String? = nil,
        wine: Wine? = nil
    ) {
        self.id = id
        self.date = date
        self.rating = rating
        self.pricePaid = pricePaid
        self.location = location
        self.memo = memo
        self.wine = wine
    }
}

extension Tasting {
    var ratingText: String {
        String(format: "%.1f", rating)
    }
}
