import UIKit
import SwiftUI
import Combine

class PropertyWrapperController: UIViewController {

    class ClassA {
        @DebugValue(name: "id") var id: Int = 0
        var name: String = "none"
    }
    
    class ClassB {
        @Proxy(\ClassB.item.name) var proxyName
        var item: ClassA = ClassA()
    }
    
    class UserInfo: ObservableObject, CustomStringConvertible {
        var id: Int
        @Published var name: String
        init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
        func someChanges() {
            self.id = self.id + 1
            self.objectWillChange.send() // called after modification to have actual value in observers
        }
        var description : String { return "id: \(id), name: \(name)" }
    }
    
    weak var counterLabel: UILabel!
    
    var cancellables = Set<AnyCancellable>()
    
    @UserDefault(key: "viewCounter", defaultValue: 0)
    var viewCounter: Int
    
    @Published
    var observedViewCounter: Int = 0
    
    @ObservedObject
    var userInfo = UserInfo(id: 1, name: "alex")
    
    @Tags(.unique)
    @Tags(.ignore, .optional)
    var tagsDemo: Int = 0
    
    @FakeStorage(\.fileStorage)
    var storedName: String = "name"

    var bindedValue = ""
    var binding: Binding<String>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.viewCounter += 1
        
        // Binding
        self.binding = Binding<String> {
            return self.bindedValue
        } set: { value in
            self.bindedValue = value
            print("bindedValue = \(value)")
        }
        
        // UserInfo observer
        self.userInfo.objectWillChange.sink { [weak self] value in
            guard let self else { return }
            print("User info will change: \(self.userInfo), \(value)")
            DispatchQueue.main.async {
                print("User info did change: \(self.userInfo)")
            }
        }.store(in: &cancellables)
        self.userInfo.$name.sink { value in
            print("Name changed: \(value)")
        }.store(in: &cancellables)
        
        // Published
        self.$observedViewCounter.sink { [weak self] value in
            guard let self else { return }
            print("Observed counter changed: \(value)")
            self.viewCounter = value
            self.counterLabel.text = "Views counter: \(value)"
        }.store(in: &cancellables)
        
        
        XListView(views: [
            UI.label(text: "").also({
                self.counterLabel = $0
                self.observedViewCounter = self.viewCounter
            }),
            UI.stackView(axis: .horizontal, spacing: 8, views: [
                UI.button("+", onTap: { [weak self] in
                    guard let self else { return }
                    self.observedViewCounter = self.viewCounter + 1
                }),
                UI.button("Reset", onTap: { [weak self] in
                    guard let self else { return }
                    self.observedViewCounter = 0
                }),
                UI.button("Remove", onTap: { [weak self] in
                    guard let self else { return }
                    self._viewCounter.removeValue()
                    self.observedViewCounter = self.viewCounter
                }),
            ]),
            
            UI.button("Test proxy", onTap: {
                let object = ClassB()
                object.item.id = 123
                object.item.name = "alex"
                object.proxyName = "john"
                print("name: \(object.item.name)")
            }),
            
            UI.stackView(axis: .horizontal, spacing: 8, views: [
                UI.button("Change user info", onTap: { [weak self] in
                    guard let self else { return }
                    self.userInfo.name = .random(count: 10)
                }),
                UI.button("Change manually", onTap: { [weak self] in
                    guard let self else { return }
                    self.userInfo.someChanges()
                }),
            ]),
            
            UI.button("Get tags", onTap: { [weak self] in
                guard let self else { return }
                print("Tags: \(self._tagsDemo.tags), \(self._tagsDemo.wrappedValue.tags)")
                print("All tags: \(self._tagsDemo.getAllTags())")
                print("Contains tag: \(self._tagsDemo.contains(.optional))")
            }),
            
            UI.button("Change bindable", onTap: { [weak self] in
                guard let self else { return }
                self.binding.wrappedValue = String.random(count: 10)
            }),
        ]).add(toParentView: self.view)
    }
}



protocol PropertyTagProtocol {
    func contains(_ tag: PropertyTag) -> Bool
    func getAllTags() -> Set<PropertyTag>
}

enum PropertyTag: String, CustomStringConvertible {
    var description: String { self.rawValue }
    case ignore
    case key
    case unique
    case optional
}

@propertyWrapper
struct Tags<Value>: PropertyTagProtocol {
    
    private var value: Value
    var tags: Set<PropertyTag>
    
    init(wrappedValue: Value, _ tags: PropertyTag...) {
        self.value = wrappedValue
        self.tags = Set(tags)
    }
    
    var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }
    
    func contains(_ tag: PropertyTag) -> Bool {
        return tags.contains(tag) || (value as? PropertyTagProtocol)?.contains(tag) ?? false
    }
    
    func getAllTags() -> Set<PropertyTag> {
        var allTags: Set<PropertyTag> = tags
        if let tagValue = value as? PropertyTagProtocol {
            allTags.formUnion(tagValue.getAllTags())
        }
        return allTags
    }
}



@propertyWrapper
struct FakeStorage<Value> {

    struct PropertyValues {
        let fileStorage = "file"
        let system = "system"
        let memory = "memory"
    }
    
    private var value: Value
    var storageName: String
    
    init(wrappedValue: Value, _ keyPath: KeyPath<PropertyValues, String>) {
        self.value = wrappedValue
        self.storageName = PropertyValues()[keyPath: keyPath]
    }
    
    var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }
}
