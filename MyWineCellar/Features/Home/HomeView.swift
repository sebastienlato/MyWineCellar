import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
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
                    MostRecentWineCard(wine: mostRecentWine)
                    Button {
                        appState.libraryFilter = .wishlist
                        appState.selectedTab = .library
                    } label: {
                        StatCard(
                            title: "Wishlist",
                            subtitle: "\(wishlistCount) wines",
                            systemImage: "heart.fill"
                        )
                    }
                    .buttonStyle(.plain)
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

    private var mostRecentWine: Wine? {
        wines.max(by: { $0.createdAt < $1.createdAt })
    }
}

private struct MostRecentWineCard: View {
    let wine: Wine?

    var body: some View {
        Group {
            if let wine {
                NavigationLink {
                    WineDetailView(wine: wine)
                } label: {
                    content(for: wine)
                }
                .buttonStyle(.plain)
            } else {
                emptyState
            }
        }
    }

    private func content(for wine: Wine) -> some View {
        HStack(spacing: Theme.Spacing.md) {
            WineThumb(photoFilename: wine.photoFilename)

            VStack(alignment: .leading, spacing: 4) {
                Text("Most Recent")
                    .font(.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)

                Text(wine.name)
                    .font(.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .lineLimit(1)

                Text(regionLine(for: wine))
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)

                Text(relativeDate(wine.createdAt))
                    .font(.caption)
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

    private var emptyState: some View {
        HStack(spacing: Theme.Spacing.md) {
            Image(systemName: "clock.fill")
                .font(.title3)
                .foregroundStyle(Theme.Colors.textSecondary)
                .frame(width: 44, height: 44)
                .background(Theme.Colors.card)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.chip))

            VStack(alignment: .leading, spacing: 4) {
                Text("Most Recent")
                    .font(.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Text("Add your first wine to see it here")
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

    private func regionLine(for wine: Wine) -> String {
        let region = wine.region?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let country = wine.country?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let parts = [region, country].filter { !$0.isEmpty }
        return parts.isEmpty ? "Unknown region" : parts.joined(separator: ", ")
    }

    private func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

private struct WineThumb: View {
    let photoFilename: String?

    var body: some View {
        Group {
            if let photoFilename, let image = PhotoStore.loadImage(filename: photoFilename) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "wineglass.fill")
                    .font(.title3)
                    .foregroundStyle(Theme.Colors.textSecondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Theme.Colors.charcoal)
            }
        }
        .frame(width: 56, height: 56)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.chip))
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
        .environmentObject(AppState())
}
