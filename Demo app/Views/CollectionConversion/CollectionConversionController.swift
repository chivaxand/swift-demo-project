import UIKit

class CollectionConversionController: UIViewController {

    struct Person: CustomStringConvertible {
        let name: String
        let age: Int?
        var description: String {
            return "{ name: \(name), age: \(age?.description ?? "nil") }"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        let people = [
            Person(name: "Alice", age: 30),
            Person(name: "Charlie", age: 30),
            Person(name: "Bob", age: nil),
            Person(name: "David", age: nil),
            Person(name: "Alex", age: 25),
            Person(name: "Carl", age: 46),
        ]
        
        XListView(views: [
            UI.button("Chained", onTap: {
                Self.printArray("Chained", people.chained(by: \.age))
            }),
            
            UI.button("Associate", onTap: {
                Self.printDictionary("Associated by", people.associate(by: \.age))
            }),
            
            UI.button("Find", onTap: {
                let firstIndex = people.firstIndex(where: { $0.age == nil })
                print("First index: \(firstIndex?.description ?? "nil")")
                let lastIndex = people.lastIndex(where: { $0.age == nil })
                print("Last index: \(lastIndex?.description ?? "nil")")
                let firstFound = people.first(where: { $0.age == nil })
                print("First found: \(firstFound?.description ?? "nil")")
            }),
            
            UI.button("Filter", onTap: {
                Self.printArray("Filtered", people.filter { $0.age == nil } )
            }),
        ]).add(toParentView: self.view)
    }
    
    static func printArray(_ title: String, _ array: [CustomStringConvertible]) {
        print("\(title):\n\(array.map { $0.description }.joined(separator: "\n"))")
    }
    
    static func printDictionary<Key, Value>(_ title: String, _ dictionary: [Key?: Value]) where Key: Hashable, Value: CustomStringConvertible {
        print("\(title):")
        for (key, value) in dictionary {
            print("\(key == nil ? "nil" : String(describing: key!)) : \(value)")
        }
    }

}

