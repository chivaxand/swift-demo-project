import SwiftUI

struct SUIRadioButton: View {
    @State private var selectedColor: String = "Red"
    let colors = ["Red", "Green", "Blue"]
    
    var body: some View {
        VStack {
            RadioGroup(items: colors, selectedId: $selectedColor)
                .padding()
            Text("Selected: \(selectedColor)")
                .padding()
        }
    }
}

struct RadioGroup<Item: Hashable>: View {
    let items: [Item]
    @Binding var selectedId: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(items, id: \.self) { item in
                RadioButton(id: item, label: "\(item)", selectedId: $selectedId)
                    .padding(.vertical, 4)
            }
        }
    }
}

struct RadioButton<Item: Hashable>: View {
    let id: Item
    let label: String
    @Binding var selectedId: Item
    
    var body: some View {
        Button(action: {
            selectedId = id
        }) {
            HStack {
                Image(systemName: selectedId == id ? "largecircle.fill.circle" : "circle")
                    .foregroundColor(selectedId == id ? .blue : .gray)
                Text(label)
            }
        }
        .buttonStyle(.plain)
    }
}


#Preview {
    SUIRadioButton()
}
