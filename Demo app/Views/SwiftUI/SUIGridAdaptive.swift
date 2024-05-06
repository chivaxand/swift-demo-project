import SwiftUI


fileprivate struct Item: Identifiable {
    let id = UUID()
    let name: String
    let price: Double
}


struct SUIGridAdaptive: View {
    fileprivate let items = [
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
    
    @State private var gridItemWidth: CGFloat = 100
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let maxCellWidth: CGFloat = 100
            let spacing: CGFloat = 2
            let columnCount = max(1, Int(screenWidth / maxCellWidth))
            let availableWidth = screenWidth - CGFloat(columnCount - 1) * 2
            let cellSize = availableWidth / CGFloat(columnCount) - spacing
            
            let columns = [
                GridItem(.adaptive(minimum: gridItemWidth), spacing: spacing)
            ]
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(items, id: \.id) { item in
                        ItemView(item: item)
                            .frame(width: cellSize, height: cellSize)
                    }
                }
            }
        }
    }
}


fileprivate struct ItemView: View {
    let item: Item
    
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.cyan)
        .cornerRadius(8)
    }
}


#Preview {
    SUIGridAdaptive()
}
