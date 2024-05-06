import SwiftUI

struct SUIMenu: View {
    private let categories = ["Category 1", "Category 2", "Category 3"]
    
    @State private var selectedCategory: String = ""
    @State private var age = 20
    @State private var showingActionSheet = false
    @State private var showingPopover = false
    @State private var selectedColor = Color.red
    @State private var selectedDate = Date()

    var body: some View {
        List {
            Section(header: Text("Category")) {
                Menu {
                    Picker("Select a category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(InlinePickerStyle())
                } label: {
                    Text("Category").foregroundColor(.black)
                    Spacer()
                    Text(selectedCategory)
                }
                
                Menu("Other Options") {
                    Button("Option 1") { print("Option 1") }
                    Button("Option 2") { print("Option 2") }
                }
                
                Picker("Select a category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                
                Picker("Select a category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("User")) {
                Text("Age: \(age)")
                Picker(selection: $age, label: Text("Age")) {
                    ForEach(0 ..< 100) { number in
                        Text("\(number)")
                    }
                }.pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.bottom))
                
                
                Button("Show ActionSheet") {
                    showingActionSheet = true
                }
                .actionSheet(isPresented: $showingActionSheet) {
                    ActionSheet(title: Text("Select an Option"), buttons: [
                        .default(Text("Option 1")),
                        .destructive(Text("Option 2")),
                        .cancel()
                    ])
                }

                Text("Long-press me!")
                    .contextMenu {
                        Button("Option 1") { print("Option 1") }
                        Button("Option 2") { print("Option 2") }
                    }
                
                
                Button("Show Popover") {
                    showingPopover = true
                }
                .popover(isPresented: $showingPopover) {
                    VStack {
                        Color.purple
                        Text("Popover Content")
                        Button("Close") {
                            showingPopover = false
                        }
                    }
                }
                
                ColorPicker("Select a Color", selection: $selectedColor, supportsOpacity: false)
                DatePicker("Select a Date", selection: $selectedDate, displayedComponents: .date)

            }
        }
    }
}

#Preview {
    SUIMenu()
}
