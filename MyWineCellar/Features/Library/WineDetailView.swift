import PhotosUI
import SwiftUI
import SwiftData
import UIKit

struct WineDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let wine: Wine
    @State private var isPresentingAddTasting = false
    @State private var isPresentingEditWine = false
    @State private var selectedTasting: Tasting?
    @State private var tastingToDelete: Tasting?
    @State private var isShowingDeleteTastingAlert = false
    @State private var isShowingDeleteWineAlert = false
    @State private var photoSelection: PhotosPickerItem?

    var body: some View {
        ZStack(alignment: .top) {
            Theme.Colors.charcoal.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.lg) {
                    header

                    metadataSection

                    notesSection

                    tastingsSection
                }
                .padding(.horizontal, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.lg)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Add Tasting") {
                    isPresentingAddTasting = true
                }
                .foregroundStyle(Theme.Colors.wine)

                Menu {
                    Button("Edit Wine") {
                        isPresentingEditWine = true
                    }
                    Button(role: .destructive) {
                        isShowingDeleteWineAlert = true
                    } label: {
                        Text("Delete Wine")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }

            ToolbarItemGroup(placement: .topBarTrailing) {
                PhotosPicker(selection: $photoSelection, matching: .images) {
                    Label("Edit Photo", systemImage: "photo")
                }

                Button("Remove Photo") {
                    removePhoto()
                }
                .disabled(wine.photoFilename == nil)
            }
        }
        .sheet(isPresented: $isPresentingAddTasting) {
            NavigationStack {
                AddTastingView(wine: wine)
            }
            .tint(Theme.Colors.wine)
        }
        .sheet(isPresented: $isPresentingEditWine) {
            NavigationStack {
                EditWineView(wine: wine)
            }
            .tint(Theme.Colors.wine)
        }
        .sheet(item: $selectedTasting) { tasting in
            NavigationStack {
                EditTastingView(tasting: tasting)
            }
            .tint(Theme.Colors.wine)
        }
        .alert("Delete Tasting?", isPresented: $isShowingDeleteTastingAlert, presenting: tastingToDelete) { tasting in
            Button("Delete", role: .destructive) {
                deleteTasting(tasting)
            }
            Button("Cancel", role: .cancel) {
                tastingToDelete = nil
            }
        } message: { _ in
            Text("This will remove the tasting from this wine.")
        }
        .alert("Delete Wine?", isPresented: $isShowingDeleteWineAlert) {
            Button("Delete", role: .destructive) {
                deleteWine()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will delete the wine and all tastings.")
        }
        .onChange(of: photoSelection) { _, newValue in
            guard let newValue else { return }
            Task {
                if let data = try? await newValue.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        updatePhoto(with: data)
                    }
                }
            }
        }
    }

    private var header: some View {
        ZStack(alignment: .bottomLeading) {
            headerImage

            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(wine.name)
                    .font(.system(.title2, design: .serif).weight(.semibold))
                    .foregroundStyle(Theme.Colors.textPrimary)

                Text(wine.producer)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
            .padding(Theme.Spacing.lg)
        }
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private var headerImage: some View {
        Group {
            if let filename = wine.photoFilename, let image = PhotoStore.loadImage(filename: filename) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 220)
                    .clipped()
            } else {
                Image("HeroBlur")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
            }
        }
        .overlay(
            LinearGradient(
                colors: [
                    Theme.Colors.charcoal.opacity(0.1),
                    Theme.Colors.charcoal
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Details")
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)

            DetailRow(label: "Type", value: wine.type.rawValue)
            DetailRow(label: "Region", value: [wine.region, wine.country].compactMap { $0 }.joined(separator: ", "))
            DetailRow(label: "Vintage", value: wine.vintage.map(String.init) ?? "—")
            DetailRow(label: "Grape", value: wine.grape ?? "—")
            DetailRow(label: "Wishlist", value: wine.isWishlist ? "Yes" : "No")
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Notes")
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)

            Text(wine.notes?.isEmpty == false ? wine.notes! : "No notes yet")
                .foregroundStyle(Theme.Colors.textSecondary)
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private var tastingsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
            Text("Tastings")
                .font(.headline)
                .foregroundStyle(Theme.Colors.textPrimary)

            if wine.tastings.isEmpty {
                Text("No tastings yet")
                    .foregroundStyle(Theme.Colors.textSecondary)
            } else {
                VStack(spacing: Theme.Spacing.sm) {
                    ForEach(sortedTastings) { tasting in
                        TastingRow(tasting: tasting)
                            .onTapGesture {
                                selectedTasting = tasting
                            }
                            .contextMenu {
                                Button("Edit") {
                                    selectedTasting = tasting
                                }
                                Button(role: .destructive) {
                                    tastingToDelete = tasting
                                    isShowingDeleteTastingAlert = true
                                } label: {
                                    Text("Delete")
                                }
                            }
                    }
                }
            }
        }
        .padding(Theme.Spacing.lg)
        .background(Theme.Colors.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }

    private var sortedTastings: [Tasting] {
        wine.tastings.sorted { $0.date > $1.date }
    }

    private func updatePhoto(with data: Data) {
        if let existing = wine.photoFilename {
            PhotoStore.removeImage(filename: existing)
        }
        if let filename = PhotoStore.saveImageData(data) {
            wine.photoFilename = filename
        }
    }

    private func removePhoto() {
        guard let filename = wine.photoFilename else { return }
        PhotoStore.removeImage(filename: filename)
        wine.photoFilename = nil
    }

    private func deleteTasting(_ tasting: Tasting) {
        selectedTasting = nil
        tastingToDelete = nil
        modelContext.delete(tasting)
    }

    private func deleteWine() {
        if let filename = wine.photoFilename {
            PhotoStore.removeImage(filename: filename)
        }
        modelContext.delete(wine)
        dismiss()
    }
}

private struct DetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(Theme.Colors.textSecondary)
            Spacer()
            Text(value.isEmpty ? "—" : value)
                .foregroundStyle(Theme.Colors.textPrimary)
        }
        .font(.subheadline)
    }
}

private struct TastingRow: View {
    let tasting: Tasting

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(tasting.date, style: .date)
                    .foregroundStyle(Theme.Colors.textPrimary)
                Spacer()
                Text(tasting.ratingText)
                    .foregroundStyle(Theme.Colors.textPrimary)
            }
            .font(.subheadline)

            if let memo = tasting.memo, !memo.isEmpty {
                Text(memo)
                    .font(.caption)
                    .foregroundStyle(Theme.Colors.textSecondary)
            }
        }
        .padding(Theme.Spacing.md)
        .background(Theme.Colors.charcoal)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.card))
    }
}

#Preview {
    WineDetailView(wine: SampleData.sampleWines().first!)
        .modelContainer(SampleData.previewContainer())
}
