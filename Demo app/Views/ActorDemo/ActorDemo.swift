import SwiftUI

struct ActorDemo: View {
    var body: some View {
        VStack {
            Button("Test Actor") {
                testActor()
            }
        }
    }
    
    @globalActor struct GlobalUserManager {
        typealias ActorType = UserManager
        
        static var shared = UserManager()
    }
    
    actor UserManager {
        private(set) var name: String = "Guest"
        @GlobalUserManager var age = 25
        
        func updateName(_ name: String) {
            self.name = name
            print("Username updated to: \(name)")
        }
        
        nonisolated func testNonIsolated(completion: @escaping (String) -> Void) {
            print("non isolated")
            Task {
                let value = await self.name
                print("isolated: \(value)")
                completion(value)
            }
        }
    }
    
    @GlobalUserManager func actorAttributeTest() async {
        let manager = GlobalUserManager.shared
        print("attribute test: \(await manager.name)")
    }
    
    @Sendable func testAsync(userManager: UserManager) async {
        await userManager.updateName("John")
        print("Updated name: \(await userManager.name)")
    }
    
    func testActor() {
        let manager = UserManager()
        
        Task {
            print("Initial name: \(await manager.name)")
            await manager.updateName("Alex")
            print("Updated name: \(await manager.name)")
            await testAsync(userManager: manager)
            
            await actorAttributeTest()
            await MainActor.run {
                print("main actor")
            }
            
            let valueFromBlock = await withCheckedContinuation { continuation in
                GlobalUserManager.shared.testNonIsolated { value in
                    continuation.resume(returning: value)
                }
            }
            print("value from block: \(valueFromBlock)")
        }
    }
}

#Preview {
    ActorDemo()
}
