import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var wines: [Wine]
    @Query private var tastings: [Tasting]

    var body: some View {
        ZStack(alignment: .top) {
            Theme.Colors.charcoal.ignoresSafeArea()

            ZStack {
                Image("HeroBlur")
                    .resizable()
                    .scaledToFill()

                LinearGradient(
                    colors: [
                        Theme.Colors.charcoal.opacity(0.55),
                        Theme.Colors.charcoal
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(height: 240)
            .clipped()
            .ignoresSafeArea(edges: .top)

            VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                    Text("MyWineCellar")
                        .font(.system(.largeTitle, design: .serif).weight(.semibold))
                        .foregroundStyle(Theme.Colors.textPrimary)

                    Text("Discover • Track • Review")
                        .foregroundStyle(Theme.Colors.textSecondary)
                }

                VStack(spacing: Theme.Spacing.md) {
                    StatCard(
                        title: "Recent",
                        subtitle: "7d: \(recentCount7) • 30d: \(recentCount30)",
                        systemImage: "clock.fill"
                    )
                    StatCard(
                        title: "Wishlist",
                        subtitle: "\(wishlistCount) wines",
                        systemImage: "heart.fill"
                    )
                    StatCard(
                        title: "Avg Rating",
                        subtitle: averageRatingText,
                        systemImage: "chart.bar.fill"
                    )
                }

                Spacer()
            }
            .padding(.horizontal, Theme.Spacing.lg)
            .padding(.top, Theme.Spacing.lg)
            .padding(.bottom, Theme.Spacing.lg)
        }
    }

    private var recentCount7: Int {
        recentCount(days: 7)
    }

    private var recentCount30: Int {
        recentCount(days: 30)
    }

    private var wishlistCount: Int {
        wines.filter { $0.isWishlist }.count
    }

    private var averageRatingText: String {
        guard !validTastings.isEmpty else { return "—" }
        let average = validTastings.map(\.rating).reduce(0, +) / Double(validTastings.count)
        return String(format: "%.1f avg", average)
    }

    private func recentCount(days: Int) -> Int {
        let cutoff = Calendar.current.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        return validTastings.filter { $0.date >= cutoff }.count
    }

    private var validTastings: [Tasting] {
        tastings.filter { $0.wine != nil }
    }
}

private struct StatCard: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(Theme.Colors.wine)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            Spacer()
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.card)
                .stroke(Theme.Colors.divider.opacity(0.8), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }
}

#Preview {
    HomeView()
        .modelContainer(SampleData.previewContainer())
}
