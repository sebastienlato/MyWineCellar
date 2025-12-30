import SwiftUI
import SwiftData

struct AddWineView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var name = ""
    @State private var producer = ""
    @State private var vintage = ""
    @State private var type: WineType = .red
    @State private var region = ""
    @State private var country = ""
    @State private var grape = ""
    @State private var notes = ""
    @State private var isWishlist = false
    @State private var createdWine: Wine?

    var body: some View {
        NavigationStack {
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

                Section("Notes") {
                    Toggle("Wishlist", isOn: $isWishlist)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(4, reservesSpace: true)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.Colors.charcoal)
            .navigationTitle("Add Wine")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveWine() }
                        .disabled(name.isEmpty || producer.isEmpty)
                }
            }
            .navigationDestination(item: $createdWine) { wine in
                WineDetailView(wine: wine)
            }
            .tint(Theme.Colors.wine)
        }
    }

    private func saveWine() {
        let wine = Wine(
            name: name,
            producer: producer,
            vintage: Int(vintage),
            region: region.isEmpty ? nil : region,
            country: country.isEmpty ? nil : country,
            grape: grape.isEmpty ? nil : grape,
            type: type,
            notes: notes.isEmpty ? nil : notes,
            isWishlist: isWishlist
        )
        modelContext.insert(wine)
        createdWine = wine
        resetForm()
    }

    private func resetForm() {
        name = ""
        producer = ""
        vintage = ""
        type = .red
        region = ""
        country = ""
        grape = ""
        notes = ""
        isWishlist = false
    }
}

#Preview {
    AddWineView()
        .modelContainer(SampleData.previewContainer())
}
