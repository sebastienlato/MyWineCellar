import Foundation
import SwiftData

enum SampleData {
    static func previewContainer() -> ModelContainer {
        let schema = Schema([Wine.self, Tasting.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        let context = ModelContext(container)

        let wines = sampleWines()
        wines.forEach { context.insert($0) }
        try? context.save()

        return container
    }

    static func sampleWines() -> [Wine] {
        let burgundy = Wine(
            name: "Clos de Vougeot",
            producer: "Chateau de la Tour",
            vintage: 2018,
            region: "Burgundy",
            country: "France",
            grape: "Pinot Noir",
            type: .red,
            notes: "Silky texture with dark cherry."
        )

        let tasting1 = Tasting(date: daysAgo(3), rating: 4.5, location: "Home", memo: "Elegant finish.")
        tasting1.wine = burgundy
        burgundy.tastings.append(tasting1)

        let champagne = Wine(
            name: "Grande Cuvée",
            producer: "Krug",
            vintage: 2011,
            region: "Champagne",
            country: "France",
            grape: "Chardonnay",
            type: .sparkling
        )

        let tasting2 = Tasting(date: daysAgo(12), rating: 4.0, location: "Anniversary", memo: "Toasty notes.")
        tasting2.wine = champagne
        champagne.tastings.append(tasting2)

        let napa = Wine(
            name: "Opus One",
            producer: "Opus One",
            vintage: 2016,
            region: "Napa Valley",
            country: "USA",
            grape: "Cabernet Sauvignon",
            type: .red,
            isWishlist: true
        )

        return [burgundy, champagne, napa]
    }

    private static func daysAgo(_ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
    }
}
