import Foundation
import CoreData

@objc(DBToDoListItem)
public class DBToDoListItem: NSManagedObject, Identifiable {

    @NSManaged public var date: Date?
    @NSManaged public var text: String?
    @NSManaged public var uuid: UUID?

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBToDoListItem> {
        return NSFetchRequest<DBToDoListItem>(entityName: "DBToDoListItem")
    }

}
