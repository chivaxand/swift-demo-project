import Foundation
import Combine

@propertyWrapper
struct Proxy<EnclosingType, Value> {
    typealias ValueKeyPath = ReferenceWritableKeyPath<EnclosingType, Value>
    typealias SelfKeyPath = ReferenceWritableKeyPath<EnclosingType, Self>
    
    private let keyPath: ValueKeyPath

    @available(*, unavailable, message: "@Proxy can only be applied to classes")
    var wrappedValue: Value { get { fatalError() } set { fatalError() } }
    
    init(_ keyPath: ValueKeyPath) {
        self.keyPath = keyPath
    }
    
    static subscript(
        _enclosingInstance instance: EnclosingType,
        wrapped wrappedKeyPath: ValueKeyPath,
        storage storageKeyPath: SelfKeyPath
    ) -> Value {
        get {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            return instance[keyPath: keyPath]
        }
        set {
            let keyPath = instance[keyPath: storageKeyPath].keyPath
            instance[keyPath: keyPath] = newValue
        }
    }
    
}


@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    var container: UserDefaults = .standard

    var wrappedValue: T {
        get {
            return container.object(forKey: key) as? T ?? defaultValue
        }
        set {
            container.set(newValue, forKey: key)
        }
    }
    
    /** self._someValue.removeValue()  */
    func removeValue() {
        container.removeObject(forKey: key)
    }
}


@propertyWrapper
struct DebugValue<T> {
    private var value: T
    private let name: String

    init(wrappedValue: T, name: String = "") {
        print("Init '\(name)' = \(wrappedValue)")
        self.value = wrappedValue
        self.name = name
    }

    var wrappedValue: T {
        get {
            print("Get '\(name)' = \(value)")
            return value
        }
        set {
            print("Set '\(name)' = \(newValue)")
            value = newValue
        }
    }
}


