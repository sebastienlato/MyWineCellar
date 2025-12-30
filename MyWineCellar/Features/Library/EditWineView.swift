import PhotosUI
import SwiftUI
import SwiftData
import UIKit

struct EditWineView: View {
    @Environment(\.dismiss) private var dismiss
    let wine: Wine

    @State private var name: String
    @State private var producer: String
    @State private var vintage: String
    @State private var type: WineType
    @State private var region: String
    @State private var country: String
    @State private var grape: String
    @State private var notes: String
    @State private var isWishlist: Bool
    @State private var photoSelection: PhotosPickerItem?
    @State private var photoData: Data?
    @State private var removePhoto = false

    init(wine: Wine) {
        self.wine = wine
        _name = State(initialValue: wine.name)
        _producer = State(initialValue: wine.producer)
        _vintage = State(initialValue: wine.vintage.map(String.init) ?? "")
        _type = State(initialValue: wine.type)
        _region = State(initialValue: wine.region ?? "")
        _country = State(initialValue: wine.country ?? "")
        _grape = State(initialValue: wine.grape ?? "")
        _notes = State(initialValue: wine.notes ?? "")
        _isWishlist = State(initialValue: wine.isWishlist)
    }

    var body: some View {
        Form {
            Section("Basics") {
                TextField("Name", text: $name)
                TextField("Producer", text: $producer)
                TextField("Vintage", text: $vintage)
                    .keyboardType(.numberPad)
                Picker("Type", selection: $type) {
                    ForEach(WineType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
            }

            Section("Origin") {
                TextField("Region", text: $region)
                TextField("Country", text: $country)
                TextField("Grape", text: $grape)
            }

            Section("Photo") {
                PhotosPicker(selection: $photoSelection, matching: .images) {
                    HStack {
                        if let image = previewImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 56, height: 56)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.chip))
                        } else {
                            Image(systemName: "camera.fill")
                                .foregroundStyle(Theme.Colors.textSecondary)
                                .frame(width: 56, height: 56)
                                .background(Theme.Colors.card)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.Radius.chip))
                        }

                        Text(previewImage == nil ? "Add Photo" : "Change Photo")
                            .foregroundStyle(Theme.Colors.textPrimary)
                    }
                }

                Button("Remove Photo") {
                    removePhoto = true
                    photoSelection = nil
                    photoData = nil
                }
                .disabled(previewImage == nil && wine.photoFilename == nil)
            }

            Section("Notes") {
                Toggle("Wishlist", isOn: $isWishlist)
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(4, reservesSpace: true)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Theme.Colors.charcoal)
        .navigationTitle("Edit Wine")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveChanges() }
                    .disabled(name.isEmpty || producer.isEmpty)
            }
        }
        .tint(Theme.Colors.wine)
        .onChange(of: photoSelection) { _, newValue in
            guard let newValue else {
                photoData = nil
                return
            }
            Task {
                if let data = try? await newValue.loadTransferable(type: Data.self) {
                    await MainActor.run {
                        removePhoto = false
                        photoData = data
                    }
                }
            }
        }
    }

    private var previewImage: UIImage? {
        if let photoData, let image = UIImage(data: photoData) {
            return image
        }
        if removePhoto {
            return nil
        }
        if let filename = wine.photoFilename {
            return PhotoStore.loadImage(filename: filename)
        }
        return nil
    }

    private func saveChanges() {
        wine.name = name
        wine.producer = producer
        wine.vintage = Int(vintage)
        wine.type = type
        wine.region = region.isEmpty ? nil : region
        wine.country = country.isEmpty ? nil : country
        wine.grape = grape.isEmpty ? nil : grape
        wine.notes = notes.isEmpty ? nil : notes
        wine.isWishlist = isWishlist

        if removePhoto {
            if let existing = wine.photoFilename {
                PhotoStore.removeImage(filename: existing)
            }
            wine.photoFilename = nil
        } else if let photoData {
            if let existing = wine.photoFilename {
                PhotoStore.removeImage(filename: existing)
            }
            if let filename = PhotoStore.saveImageData(photoData) {
                wine.photoFilename = filename
            }
        }

        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditWineView(wine: SampleData.sampleWines().first!)
    }
    .modelContainer(SampleData.previewContainer())
}
