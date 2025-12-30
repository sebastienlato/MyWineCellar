import SwiftUI
import SwiftData


struct EditTastingView: View {
    @Environment(\.dismiss) private var dismiss
    let tasting: Tasting

    @State private var date: Date
    @State private var rating: Double
    @State private var pricePaid: String
    @State private var location: String
    @State private var memo: String

    init(tasting: Tasting) {
        self.tasting = tasting
        _date = State(initialValue: tasting.date)
        _rating = State(initialValue: tasting.rating)
        _pricePaid = State(initialValue: tasting.pricePaid.map { String($0) } ?? "")
        _location = State(initialValue: tasting.location ?? "")
        _memo = State(initialValue: tasting.memo ?? "")
    }

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
        .navigationTitle("Edit Tasting")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { saveChanges() }
            }
        }
    }

    private func saveChanges() {
        tasting.date = date
        tasting.rating = rating
        tasting.pricePaid = parsePrice(pricePaid)
        tasting.location = location.isEmpty ? nil : location
        tasting.memo = memo.isEmpty ? nil : memo
        dismiss()
    }

    private func parsePrice(_ text: String) -> Double? {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        return Double(normalized)
    }
}

#Preview {
    NavigationStack {
        EditTastingView(tasting: SampleData.sampleWines().first!.tastings.first!)
    }
    .modelContainer(SampleData.previewContainer())
}
