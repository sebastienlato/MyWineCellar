import SwiftUI
import SwiftData

struct AddTastingView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    let wine: Wine

    @State private var date = Date()
    @State private var rating: Double = 4.0
    @State private var pricePaid = ""
    @State private var location = ""
    @State private var memo = ""

    var body: some View {
        Form {
            Section("Tasting") {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                    Text("Rating: \(String(format: "%.1f", rating))")
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Slider(value: $rating, in: 0...5, step: 0.5)
                        .tint(Theme.Colors.wine)
                }
                TextField("Price Paid", text: $pricePaid)
                    .keyboardType(.decimalPad)
                TextField("Location", text: $location)
            }

            Section("Notes") {
                TextField("Memo", text: $memo, axis: .vertical)
                    .lineLimit(3, reservesSpace: true)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Theme.Colors.charcoal)
        .navigationTitle("Add Tasting")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveTasting() }
            }
        }
    }

    private func saveTasting() {
        let tasting = Tasting(
            date: date,
            rating: rating,
            pricePaid: parsePrice(pricePaid),
            location: location.isEmpty ? nil : location,
            memo: memo.isEmpty ? nil : memo,
            wine: wine
        )
        wine.tastings.append(tasting)
        modelContext.insert(tasting)
        dismiss()
    }

    private func parsePrice(_ text: String) -> Double? {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
    }
}

#Preview {
    NavigationStack {
        AddTastingView(wine: SampleData.sampleWines().first!)
    }
    .modelContainer(SampleData.previewContainer())
}
