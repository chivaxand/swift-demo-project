import SwiftUI

struct EditableListExpandable: View {
    
    struct Fruit: Identifiable {
        let id = UUID()
        let name: String
        let description: String
        var isExpanded: Bool = false
    }
    
    @State private var fruits: [Fruit] = [
        Fruit(name: "Apple", description: "A sweet and crunchy fruit."),
        Fruit(name: "Banana", description: "A yellow fruit with a soft texture."),
        Fruit(name: "Orange", description: "A citrus fruit with juicy segments."),
        Fruit(name: "Grapes", description: "Small, juicy fruits that grow in clusters.")
    ]

    var body: some View {
        List {
            Section(header: Text("Fruits")) {
                ForEach(fruits.indices, id: \.self) { index in
                    DisclosureGroup(isExpanded: $fruits[index].isExpanded) {
                        Text(fruits[index].description)
                            .padding()
                    } label: {
                        HStack {
                            Text(fruits[index].name)
                        }
                    }
                }
                .onDelete(perform: deleteItem)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    func deleteItem(at offsets: IndexSet) {
        print("Delete: \(offsets)")
        fruits.remove(atOffsets: offsets)
    }
    
}

#Preview {
    EditableListExpandable()
}
