import SwiftUI

struct SUINavigationStack: View {
    // @State private var navPath = NavigationPath()
    @State private var navPath: [Color] = []
    
    var body: some View {
        NavigationStack(path: $navPath) {
            List {
                Button("Next") {
                    navPath.append(Color.red)
                }
                NavigationLink("Mint", value: Color.mint)
                NavigationLink("Pink", value: Color.pink)
                NavigationLink("Teal", value: Color.teal)
                NavigationLink("Cyan", value: Color.cyan)
            }
            .navigationDestination(for: Color.self) { color in
                SUIColorView(color: color)
            }
            .navigationTitle("Colors")
        }
        .navigationBarTitle("Navigation stack")
    }
}


#Preview {
    SUINavigationStack()
}
