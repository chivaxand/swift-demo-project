import SwiftUI


struct SUINavigationView: View {
    @State private var showView1 = false
    @State private var showView2 = false
    @State private var controllerPresented = false
    
    var body: some View {
        NavigationStack { // required for "navigationDestination"
            VStack {
                
                NavigationLink("Direct link") {
                    Text("View to display")
                }
                
                Button("NavigationLink", action: {
                    self.showView1 = true
                })
                
                NavigationLink(
                    destination: SUIColorView(color: .blue),
                    isActive: $showView1)
                {
                    EmptyView()
                }
                
                
                Button("NavigationStack") {
                    self.showView2 = true
                }
                .navigationDestination(isPresented: $showView2) {
                    SUIColorView(color: .green)
                }
                
                
                Button("UIViewController") {
                    self.controllerPresented = true
                }
                .sheet(isPresented: $controllerPresented) {
                    ColorControllerWrapped()
                        .ignoresSafeArea()
                    
                }
            }
        }
        .navigationBarTitle("Navigation")
    }
}


fileprivate struct ColorControllerWrapped: UIViewControllerRepresentable {
    typealias UIViewControllerType = ColorController
    
    func makeUIViewController(context: Context) -> ColorController {
        let controller = ColorController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: ColorController, context: Context) {
        print("Update controller, context: \(context)")
    }
}


#Preview {
    SUINavigationView()
}
