import SwiftUI

struct ClassStructView: View {
    var body: some View {
        VStack {
            Button("Measure") {
                print("Test started")
                measuteClassItems()
                measureStructItems()
                print("Test finished")
            }
        }
    }
    
    class UserClass {
        var firstName: String
        var lastName: String
        var email: String
        
        init(firstName: String, lastName: String, email: String) {
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
        }
    }

    struct UserStruct {
        var firstName: String
        var lastName: String
        var email: String
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func measureTime(_ name: String, block: @escaping () -> Void) {
        let startTime = CFAbsoluteTimeGetCurrent()
        block()
        let endTime = CFAbsoluteTimeGetCurrent()
        print("\(name): \(endTime - startTime) seconds")
    }
    
    static let itemsCount = 200_000
    
    static var preparedItems: [UserClass] = {
        var items: [UserClass] = []
        for _ in 0..<Self.itemsCount {
            let user = UserClass(firstName: randomString(length: 8),
                                 lastName: randomString(length: 8),
                                 email: randomString(length: 10) + "@example.com")
            items.append(user)
        }
        return items
    }()
    
    func measuteClassItems() {
        var items: [UserClass] = []
        let preparedItems = Self.preparedItems
        
        measureTime("Class, create") {
            for i in 0..<preparedItems.count {
                let existingItem = preparedItems[i]
                let user = UserClass(firstName: existingItem.firstName,
                                     lastName: existingItem.lastName,
                                     email: existingItem.email)
                items.append(user)
            }
        }
        
        measureTime("Class, search") {
            let strintToFound = items.last!.firstName
            _ = items.lastIndex(where: { $0.firstName == strintToFound })
        }
    }
    
    func measureStructItems() {
        var items: [UserStruct] = []
        let preparedItems = Self.preparedItems
        
        measureTime("Struct, create") {
            for i in 0..<preparedItems.count {
                let existingItem = preparedItems[i]
                let user = UserStruct(firstName: existingItem.firstName,
                                     lastName: existingItem.lastName,
                                     email: existingItem.email)
                items.append(user)
            }
        }
        
        measureTime("Struct, search") {
            let strintToFound = items.last!.firstName
            _ = items.lastIndex(where: { $0.firstName == strintToFound })
        }
    }
}

#Preview {
    ClassStructView()
}
