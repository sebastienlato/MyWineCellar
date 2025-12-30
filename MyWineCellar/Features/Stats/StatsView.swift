import SwiftUI
import SwiftData

struct StatsView: View {
    @Query private var wines: [Wine]
    @Query private var tastings: [Tasting]

    var body: some View {
        ZStack {
            Theme.Colors.charcoal.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    overviewSection

                    if validTastings.isEmpty {
                        emptyStateSection
                    } else {
                        ratingsByTypeSection
                        ratingsByRegionSection
                        trendsSection
                    }
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.lg)
            }
        }
        .navigationTitle("Stats")
    }

    private var overviewSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Overview")
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: Theme.Spacing.sm),
                GridItem(.flexible(), spacing: Theme.Spacing.sm)
            ], spacing: Theme.Spacing.sm) {
                StatCard(title: "Total Wines", value: "\(wines.count)")
                StatCard(title: "Total Tastings", value: "\(validTastings.count)")
                StatCard(title: "Wishlist", value: "\(wishlistCount)")
                StatCard(title: "Avg Rating", value: averageRatingText)
            }
        }
    }

    private var emptyStateSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("No tastings yet")
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)
            Text("Add your first tasting to see ratings, regions, and trends.")
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private var ratingsByTypeSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Ratings by Type")
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)

            VStack(spacing: Theme.Spacing.sm) {
                ForEach(ratingsByType) { stat in
                    StatRow(
                        title: stat.type.rawValue,
                        subtitle: "\(stat.count) tastings",
                        value: String(format: "%.1f", stat.average)
                    )
                }
            }
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private var ratingsByRegionSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Ratings by Region")
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)

            VStack(spacing: Theme.Spacing.sm) {
                ForEach(topRegions) { stat in
                    StatRow(
                        title: stat.region,
                        subtitle: "\(stat.count) tastings",
                        value: String(format: "%.1f", stat.average)
                    )
                }
            }
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private var trendsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("90-Day Trend")
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)

            if weeklyTrends.isEmpty {
                Text("No tastings in the last 90 days.")
                    .foregroundStyle(Theme.Colors.textSecondary)
            } else {
                TrendChart(weeks: weeklyTrends)
            }
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private var wishlistCount: Int {
        wines.filter { $0.isWishlist }.count
    }

    private var averageRatingText: String {
        guard !validTastings.isEmpty else { return "—" }
        let average = validTastings.map(\.rating).reduce(0, +) / Double(validTastings.count)
        return String(format: "%.1f", average)
    }

    private var ratingsByType: [TypeStat] {
        var buckets: [WineType: (sum: Double, count: Int)] = [:]
        for tasting in validTastings {
            guard let type = tasting.wine?.type else { continue }
            let current = buckets[type] ?? (0, 0)
            buckets[type] = (current.sum + tasting.rating, current.count + 1)
        }
        return WineType.allCases.compactMap { type in
            guard let bucket = buckets[type] else { return nil }
            return TypeStat(type: type, average: bucket.sum / Double(bucket.count), count: bucket.count)
        }
    }

    private var topRegions: [RegionStat] {
        var buckets: [String: (sum: Double, count: Int)] = [:]
        for tasting in validTastings {
            let region = tasting.wine?.region?.trimmingCharacters(in: .whitespacesAndNewlines)
            let key = region?.isEmpty == false ? region! : "Unknown"
            let current = buckets[key] ?? (0, 0)
            buckets[key] = (current.sum + tasting.rating, current.count + 1)
        }

        return buckets.map { key, bucket in
            RegionStat(region: key, average: bucket.sum / Double(bucket.count), count: bucket.count)
        }
        .sorted { lhs, rhs in
            if lhs.count == rhs.count {
                return lhs.region < rhs.region
            }
            return lhs.count > rhs.count
        }
        .prefix(10)
        .map { $0 }
    }

    private var weeklyTrends: [WeekStat] {
        let calendar = Calendar.current
        let cutoff = calendar.date(byAdding: .day, value: -90, to: Date()) ?? .distantPast
        var buckets: [Date: (sum: Double, count: Int)] = [:]

        for tasting in validTastings where tasting.date >= cutoff {
            guard let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: tasting.date)?.start else { continue }
            let current = buckets[startOfWeek] ?? (0, 0)
            buckets[startOfWeek] = (current.sum + tasting.rating, current.count + 1)
        }

        return buckets.map { key, bucket in
            WeekStat(startDate: key, average: bucket.sum / Double(bucket.count))
        }
        .sorted { $0.startDate < $1.startDate }
    }

    private var validTastings: [Tasting] {
        tastings.filter { $0.wine != nil }
    }
}

private struct StatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(Theme.Colors.textSecondary)
            Text(value)
                .font(.title3)
                .foregroundStyle(Theme.Colors.textPrimary)
        }
        .padding(Theme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }
}

private struct StatRow: View {
    let title: String
    let subtitle: String
    let value: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.charcoal)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }
}

private struct TrendChart: View {
    let weeks: [WeekStat]

    var body: some View {
        let maxAverage = weeks.map(\.average).max() ?? 0

        HStack(alignment: .bottom, spacing: Theme.Spacing.xs) {
            ForEach(weeks) { week in
                RoundedRectangle(cornerRadius: Theme.Radius.chip)
                    .fill(Theme.Colors.wine)
                    .frame(width: 12, height: barHeight(for: week.average, maxAverage: maxAverage))
            }
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .bottomLeading)
    }

    private func barHeight(for value: Double, maxAverage: Double) -> CGFloat {
        guard maxAverage > 0 else { return 8 }
        let scaled = value / maxAverage
        return max(8, scaled * 120)
    }
}

private struct TypeStat: Identifiable {
    let type: WineType
    let average: Double
    let count: Int

    var id: String { type.rawValue }
}

private struct RegionStat: Identifiable {
    let region: String
    let average: Double
    let count: Int

    var id: String { region }
}

private struct WeekStat: Identifiable {
    let startDate: Date
    let average: Double

    var id: Date { startDate }
}

#Preview {
    NavigationStack {
        StatsView()
    }
    .modelContainer(SampleData.previewContainer())
}
