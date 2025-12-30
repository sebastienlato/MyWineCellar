import SwiftData

#if DEBUG
enum OrphanTastingCleanup {
    static func purge(in context: ModelContext) {
        let descriptor = FetchDescriptor<Tasting>()
        if let tastings = try? context.fetch(descriptor) {
            tastings.filter { $0.wine == nil }
                .forEach { context.delete($0) }
        }
    }
}
#endif
