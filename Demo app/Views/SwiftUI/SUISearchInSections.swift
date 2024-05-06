import SwiftUI

fileprivate class Item: ObservableObject, Identifiable {
    let uuid: UUID = UUID()
    @Published var name: String
    @Published var color: Color
    @Published var likeCount: Int
    
    init(name: String, color: UIColor, likeCount: Int = 0) {
        self.name = name
        self.color = Color(color)
        self.likeCount = likeCount
    }
    
    init(name: String, color: Color, likeCount: Int = 0) {
        self.name = name
        self.color = color
        self.likeCount = likeCount
    }
    
    func addLike() {
        self.likeCount += 1
        print("like: \(self.likeCount)")
    }
}

struct SUISearchInSections: View {
    @State var searchText = ""
    @State var isShowingAdd = false
    
    @State fileprivate var countries = [
        Item(name: "USA", color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
        Item(name: "Canada", color: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)),
        Item(name: "UK", color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        Item(name: "Germany", color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
        Item(name: "France", color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
        Item(name: "Italy", color: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)),
        Item(name: "Japan", color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),
        Item(name: "Australia", color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
        Item(name: "China", color: #colorLiteral(red: 1, green: 0.6470588235, blue: 0, alpha: 1)),
        Item(name: "India", color: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
        Item(name: "Brazil", color: #colorLiteral(red: 0, green: 0.7529411765, blue: 1, alpha: 1)),
        
    ]
    
    fileprivate let cities = [
        Item(name: "Berlin", color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
        Item(name: "Paris", color: #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)),
        Item(name: "Rome", color: #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)),
        Item(name: "Tokyo", color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
        Item(name: "New York", color: #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
        Item(name: "Los Angeles", color: #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)),
        Item(name: "Toronto", color: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        Item(name: "London", color: #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)),
        Item(name: "Sydney", color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)),
    ]
    
    fileprivate func filterItems(_ items: [Item], searchText: String) -> [Item] {
        if searchText.isEmpty {
            return items
        } else {
            return items.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                Text("Search demo")
                    .font(.title)
                    .padding()
                
                SearchBar(text: $searchText)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                
                VStack {
                    SectionView(title: "Countries",
                                items: filterItems(countries, searchText: searchText))
                    
                    SectionView(title: "Cities",
                                items: filterItems(cities, searchText: searchText))
                    
                    CirclesSectionView(items: countries)
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBarTitle("Search in sections")
        .toolbar {
            Button("Add", systemImage: "plus") {
                self.isShowingAdd = true
            }
        }
        .sheet(isPresented: self.$isShowingAdd) {
            AddCountryView(items: $countries)
        }
    }
}

fileprivate struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
            
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)
        }
    }
}

fileprivate struct SectionView: View {
    @State private var itemToEdit: Item? = nil
    let title: String
    fileprivate let items: [Item]
    
    var body: some View {
        Section {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    if !items.isEmpty {
                        ForEach(items, id: \.name) { item in
                            ItemView(item: item)
                                .onTapGesture {
                                    itemToEdit = item
                                }
                        }
                    } else {
                        Text("No items")
                    }
                }
            }
            //.scrollTargetBehavior(.viewAligned)
            //.contentMargins(20, for: .scrollContent)
            .listRowInsets(EdgeInsets())
        } header: {
            Text(title)
                .font(.title3.bold())
                .textCase(.uppercase)
        }
        .padding(.bottom, 32)
        .sheet(item: $itemToEdit) { item in
            EditCountryView(item: item)
        }
    }
}

fileprivate struct ItemView: View {
    @ObservedObject fileprivate var item: Item
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(item.color)
                .frame(height: 200)
                .frame(minWidth: 150, maxWidth: .infinity)
            
//            Image("phone-icon")
//                .resizable()
//                .scaledToFit()
//                .frame(height: 100)

            VStack(spacing: 0) {
                Rectangle()
                    .fill(.black.opacity(0.1))
                    .frame(height: 2)
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding(8)
                    }
                    
                    Spacer()
                    
                    Button() {
                        item.addLike()
                    } label: {
                        Label(String(item.likeCount), systemImage: "hand.thumbsup")
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .foregroundStyle(.white)
                
            }
            .background(.black.opacity(0.1))
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.2), radius: 2)
        .padding(4)
    }
}

fileprivate struct CirclesSectionView: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    let items: [Item]
    
    var itemSize : CGFloat { // changed on device rotation
        return verticalSizeClass == .regular ? 100 : 50
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(items) { item in
                    Circle()
                        .foregroundStyle(item.color.gradient)
                        .frame(width: itemSize, height: itemSize)
//                        .containerRelativeFrame(.horizontal,
//                                                count: verticalSizeClass == .regular ? 2 : 4,
//                                                spacing: 16)
//                        .scrollTransition { content, phase in content
//                                .opacity(phase.isIdentity ? 1.0 : 0.0)
//                                .scaleEffect(x: phase.isIdentity ? 1.0 : 0.3,
//                                             y: phase.isIdentity ? 1.0 : 0.3)
//                                .offset(y: phase.isIdentity ? 0 : 50)
//                        }
                }
            }
//            .scrollTargetLayout()
        }
    }
}

fileprivate struct AddCountryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var color: Color = .green
    @State private var likeCount: Int = 0
    @State private var date: Date = .now
    @State private var money1: Double = 0
    @State private var money2: Double = 0
    @State private var isMoneyValid: Bool = true
    @Binding var items: [Item]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                ColorPicker("Color", selection: $color)
                Stepper("Like Count: \(likeCount)", value: $likeCount)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Money", value: $money1, format: .currency(code: "USD"))
                    .keyboardType(.decimalPad)
                TextField("Money", value: $money2, formatter: NumberFormatter())
            }
            .navigationTitle("Add country")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Add") {
                        let item = Item(name: self.name,
                                        color: self.color,
                                        likeCount: self.likeCount)
                        self.items.append(item)
                        dismiss()
                    }
                }
            }
        }
    }
}


fileprivate struct EditCountryView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name: String = ""
    @State private var color: Color = .green
    @State private var likeCount: Int = 0
    @ObservedObject var item: Item
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                ColorPicker("Color", selection: $color)
                Stepper("Like Count: \(likeCount)", value: $likeCount)
            }
            .navigationTitle("Add country")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        item.name = name
                        item.color = color
                        item.likeCount = likeCount
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            name = item.name
            color = item.color
            likeCount = item.likeCount
        }
    }
}


#Preview {
    SUISearchInSections()
}

#Preview {
    @State var items: [Item] = []
    return AddCountryView(items: $items)
}
