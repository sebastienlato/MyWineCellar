import SwiftUI
import SwiftData

struct LibraryView: View {
    @Query private var wines: [Wine]
    @State private var filter: LibraryFilter = .all
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.charcoal.ignoresSafeArea()

                VStack(spacing: Theme.Spacing.md) {
                    Picker("Filter", selection: $filter) {
                        ForEach(LibraryFilter.allCases, id: \.self) { option in
                            Text(option.title).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal, Theme.Spacing.lg)
                    .padding(.top, Theme.Spacing.sm)

                    if filteredWines.isEmpty {
                        Spacer()
                        Text("No wines yet")
                            .foregroundStyle(Theme.Colors.textSecondary)
                        Spacer()
                    } else {
                        List {
                            ForEach(filteredWines) { wine in
                                NavigationLink {
                                    WineDetailView(wine: wine)
                                } label: {
                                    WineRow(wine: wine)
                                }
                                .listRowBackground(Theme.Colors.card)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                    }
                }
            }
            .navigationTitle("Library")
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
            .tint(Theme.Colors.wine)
        }
    }

    private var filteredWines: [Wine] {
        let base = wines.filter { wine in
            switch filter {
            case .all:
                return true
            case .cellar:
                return !wine.isWishlist
            case .wishlist:
                return wine.isWishlist
            }
        }

        guard !searchText.isEmpty else {
            return base.sorted { $0.name < $1.name }
        }

        let query = searchText.lowercased()
        return base.filter { wine in
            wine.name.lowercased().contains(query)
            || wine.producer.lowercased().contains(query)
            || (wine.region?.lowercased().contains(query) ?? false)
        }
        .sorted { $0.name < $1.name }
    }
}

private enum LibraryFilter: CaseIterable {
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

private struct WineRow: View {
    let wine: Wine

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            VStack(alignment: .leading, spacing: 4) {
                Text(wine.name)
                    .font(.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 6) {
                Text(wine.latestRatingText)
                    .font(.headline)
                    .foregroundStyle(Theme.Colors.textPrimary)

                if wine.isWishlist {
                    Text("Wishlist")
                        .font(.caption)
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .padding(.horizontal, Theme.Spacing.sm)
                        .padding(.vertical, 4)
                        .background(Theme.Colors.wineDark)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(.vertical, Theme.Spacing.sm)
    }

    private var subtitle: String {
        var parts: [String] = [wine.producer]
        if let vintage = wine.vintage {
            parts.append(String(vintage))
        }
        return parts.joined(separator: " • ")
    }
}

#Preview {
    LibraryView()
        .modelContainer(SampleData.previewContainer())
}
