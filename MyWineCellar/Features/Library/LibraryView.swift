import SwiftUI
import SwiftData
import UIKit

struct LibraryView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.modelContext) private var modelContext
    @Query private var wines: [Wine]
    @State private var searchText = ""
    @State private var wineToDelete: Wine?
    @State private var isShowingDeleteAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Colors.charcoal.ignoresSafeArea()

                VStack(spacing: Theme.Spacing.md) {
                    Picker("Filter", selection: filter) {
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
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        wineToDelete = wine
                                        isShowingDeleteAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
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
            .alert("Delete Wine?", isPresented: $isShowingDeleteAlert, presenting: wineToDelete) { wine in
                Button("Delete", role: .destructive) {
                    deleteWine(wine)
                }
                Button("Cancel", role: .cancel) {
                    wineToDelete = nil
                }
            } message: { _ in
                Text("This will delete the wine and all tastings.")
            }
        }
    }

    private var filteredWines: [Wine] {
        let base = wines.filter { wine in
            switch filter.wrappedValue {
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

    private func deleteWine(_ wine: Wine) {
        if let filename = wine.photoFilename {
            PhotoStore.removeImage(filename: filename)
        }
        modelContext.delete(wine)
        wineToDelete = nil
    }

    private var filter: Binding<LibraryFilter> {
        Binding(
            get: { appState.libraryFilter },
            set: { appState.libraryFilter = $0 }
        )
    }
}

private struct WineRow: View {
    let wine: Wine

    var body: some View {
        HStack(spacing: Theme.Spacing.md) {
            thumbnail

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

    private var thumbnail: some View {
        Group {
            if let filename = wine.photoFilename, let image = PhotoStore.loadImage(filename: filename) {
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
        .environmentObject(AppState())
}
