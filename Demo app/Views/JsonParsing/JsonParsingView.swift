import SwiftUI

struct JsonParsingView: View {
    
    fileprivate let categories = try! (try! Bundle.main.data(forFile: "items.json"))
        .decodeJson(as: [Category].self)
    
    var body: some View {
        List {
            ForEach(categories, id: \.name) { category in
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 16) {
                            ForEach(category.items, id: \.name) { item in
                                VStack() {
                                    Image(systemName: category.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)

                                    Text(item.name)
                                        .font(.title3)
                                    
                                    Text(item.description)
                                        .font(.subheadline)
                                }
                                .frame(width: 200)
                            }
                        }
                        .padding(.vertical, 32)
                        .padding(.horizontal, 16)
                    }
                    .listRowInsets(EdgeInsets())
                } header: {
                    Text(category.name)
                        .font(.title3.bold())
                        .textCase(.uppercase)
                }
                .listRowSeparator(.hidden)
            }
        }
        //.listStyle(.plain)
    }
}

fileprivate struct Category: Decodable {
    var name: String
    var icon: String
    var items: [Item]
}

fileprivate struct Item: Decodable {
    var name: String
    var description: String
}


#Preview {
    JsonParsingView()
}
