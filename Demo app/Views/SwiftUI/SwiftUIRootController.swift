import SwiftUI


struct SwiftUIRootView: View {
    struct ListItem {
        let title: String
        let view: any View
    }
    
    static let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    @Environment(\.navigationController) private var navigationController

    let itemsList: [ListItem] = [
        ListItem(title: "Simple", view: SUIColorView()),
        ListItem(title: "Components", view: SUIComponents()),
        ListItem(title: "Buttons", view: SUIButtons()),
        ListItem(title: "Radio buttons", view: SUIRadioButton()),
        ListItem(title: "Alert", view: SUIAlert()),
        ListItem(title: "Navigation", view: SUINavigationView()),
        ListItem(title: "NavigationStack", view: SUINavigationStack()),
        ListItem(title: "Environment variable", 
                 view: SUIEnvironment().environmentObject(Self.appDelegate.userInfo)),
        ListItem(title: "Bind / Observed", view: SUIBindObserved()),
        ListItem(title: "Gradients", view: SUIGradient()),
        ListItem(title: "Grid", view: SUIGrid()),
        ListItem(title: "Grid adaptive", view: SUIGridAdaptive()),
        ListItem(title: "Parallax effect", view: ParallaxEffect()),
        ListItem(title: "Geometry reader", view: GeometryReaderView()),
        ListItem(title: "PreferenceKey", view: PreferenceKeyDemo()),
        ListItem(title: "Search in sections", view: SUISearchInSections()),
        ListItem(title: "Stack demo (VStack, HStack, ZStack)", view: StackDemo()),
        ListItem(title: "Editable list / expandable", view: EditableListExpandable()),
        ListItem(title: "Menu", view: SUIMenu()),
    ]

    var body: some View {
        List(itemsList, id: \.title) { item in
            let view = AnyView(item.view)
                .environment(\.navigationController, navigationController)
            NavigationLink(destination: view) {
                Text(item.title)
            }
            .listRowSeparator(.hidden)
//            ZStack(alignment: .leading) {
//                NavigationLink(destination: item.view) {
//                    EmptyView()
//                }.opacity(0)
//                Text(item.title)
//            }
        }
        .listStyle(PlainListStyle())
        .navigationBarTitle("SwiftUI")
    }
}


struct SUIColorView: View {
    @Environment(\.dismiss) private var dismiss
    var text: String
    var color: Color
    
    init(text: String = "X", color: Color = .cyan) {
        self.text = text
        self.color = color
    }
    
    var body: some View {
        ZStack {
            color.edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                Text(text)
                    .frame(width: geometry.size.width, 
                           height: geometry.size.height)
                    .foregroundColor(.white)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}


#Preview {
    SwiftUIRootView()
}
