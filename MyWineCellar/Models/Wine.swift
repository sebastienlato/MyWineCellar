import Foundation
import SwiftData

@Model
final class Wine {

    @Attribute(.unique) var id: UUID

    var name: String
    var producer: String
    var vintage: Int?

    var region: String?
    var country: String?
    var grape: String?

    // Persist as raw value for SwiftData compatibility
    var typeRaw: String

    var notes: String?
    var isWishlist: Bool
    var createdAt: Date

    @Relationship(inverse: \Tasting.wine)
    var tastings: [Tasting]

    init(
        id: UUID = UUID(),
        name: String,
        producer: String = "",
        vintage: Int? = nil,
        region: String? = nil,
        country: String? = nil,
        grape: String? = nil,
        type: WineType = .red,
        notes: String? = nil,
        isWishlist: Bool = false,
        createdAt: Date = .now,
        tastings: [Tasting] = []
    ) {
        self.id = id
        self.name = name
        self.producer = producer
        self.vintage = vintage
        self.region = region
        self.country = country
        self.grape = grape
        self.typeRaw = type.rawValue
        self.notes = notes
        self.isWishlist = isWishlist
        self.createdAt = createdAt
        self.tastings = tastings
    }

    // Convenience computed property
    var type: WineType {
        get { WineType(rawValue: typeRaw) ?? .red }
        set { typeRaw = newValue.rawValue }
    }

    var latestTasting: Tasting? {
        tastings.max(by: { $0.date < $1.date })
    }

    var latestRatingText: String {
        latestTasting?.ratingText ?? "—"
    }
}
