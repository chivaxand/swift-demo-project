import SwiftUI

struct SUIGrid: View {
    
    struct Item: Identifiable {
        let id = UUID()
        let name: String
        let price: Double
    }

    let items = [
        Item(name: "Item 1", price: 10.99),
        Item(name: "Item 2", price: 15.49),
        Item(name: "Item 3", price: 7.99),
        Item(name: "Item 4", price: 22.99),
        Item(name: "Item 5", price: 12.99),
        Item(name: "Item 6", price: 18.99),
        Item(name: "Item 7", price: 7.99),
        Item(name: "Item 8", price: 22.99),
        Item(name: "Item 9", price: 12.99),
        Item(name: "Item 10", price: 1.99),
        Item(name: "Item 11", price: 10.99),
        Item(name: "Item 12", price: 15.49),
        Item(name: "Item 13", price: 7.99),
        Item(name: "Item 14", price: 22.99),
        Item(name: "Item 15", price: 12.99),
        Item(name: "Item 16", price: 18.99),
        Item(name: "Item 17", price: 7.99),
        Item(name: "Item 18", price: 22.99),
        Item(name: "Item 19", price: 12.99),
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2),
                                     count: 3),
                      spacing: 2) {
                ForEach(items, id: \.id) { item in
                    Other.ItemView(item: item)
                }
            }
        }
    }
}

fileprivate struct Other {
    struct ItemView: View {
        let item: SUIGrid.Item
        
        var body: some View {
            VStack(spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(8)
                Text(String(format: "$%.2f", item.price))
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(8)
            }
            .frame(minWidth: 100, minHeight: 100)
            .background(Color.cyan)
            .cornerRadius(8)
        }
    }
    
}

#Preview {
    SUIGrid()
}
