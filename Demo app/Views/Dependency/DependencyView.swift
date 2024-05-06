import SwiftUI


struct DependencyView: View {
    
    fileprivate let printLogic = fn.PrintLogic()
    fileprivate let userInfo = fn.UserInfo(name: "John", id: 123)
    let dependencies: Dependencies
    
    init() {
        self.dependencies = Dependencies()
        dependencies.register(type: fn.PrintLogic.self) { dependencies in
            return fn.PrintLogic()
        }
        
        userInfo.showInfo()
    }
    
    var body: some View {
        Button("Show info") {
            userInfo.showInfo()
            let printLogic = self.dependencies.resolve(fn.PrintLogic.self)!
            printLogic.printValue("Print using resolved dependency: \(userInfo.name)")
        }
    }
}

fileprivate struct fn {
    
    // Dependency Injector
    class DependencyInjector {
        static let shared = DependencyInjector()
        private init() {}
        let printLogic = PrintLogic()
    }
    
    // Dependency property
    @propertyWrapper
    struct Dependency<T> {
        private var value: T
        
        init(_ keyPath: KeyPath<DependencyInjector, T>) {
            self.value = DependencyInjector.shared[keyPath: keyPath]
        }
        
        var wrappedValue: T {
            get { value }
            set { value = newValue }
        }
    }
    
    struct UserInfo {
        @Dependency(\.printLogic) private var printLogic
        let name: String
        let id: Int
        
        func showInfo() {
            printLogic.printValue("Print using injected dependency: \(self.name)")
        }
    }
    
    class PrintLogic {
        func printValue(_ value: String) {
            print("Value: \(value)")
        }
    }
    
}

#Preview {
    DependencyView()
}
