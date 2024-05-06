import Foundation
import SwiftData
import SwiftUI

// Database with SwiftData (CoreData alternative)

/*
@Model
class DBToDoListItem2 {
    public var date: Date
    public var text: String
    public var uuid: UUID

    init(date: Date, text: String, uuid: UUID) {
        self.date = date
        self.text = text
        self.uuid = uuid
    }
}


@main
struct SwiftDataExampleApp: App {
    let container : ModelContainer = {
        let schema = Schema([DBToDoListItem2.self])
        let container = try! ModelContainer(for: schema, migrationPlan: nil, configurations: [])
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(container)
        }
    }
} 
 
struct SomeView: View {
    @Query(sort: \DBToDoListItem2.date) var todoItems : [DBToDoListItem2]
    var body: some View {
        List {
            ForEach(todoItems) { item in
                Text(item.text)
            }
        }
    }
}

// */
