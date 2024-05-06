import Foundation

/**
 struct BindingTest {
     @CIBinding var name: String
 }
 @CIBindable var bindableValue: String = ""
 let object = BindingTest(name: $bindableValue)
*/

@propertyWrapper
class CIBindable<Value> {
    lazy private var binding: CIBinding<Value> = {
        CIBinding(get: { self.wrappedValue }, set: { self.wrappedValue = $0 })
    }()

    var projectedValue: CIBinding<Value> { binding }
    var wrappedValue: Value

    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

@propertyWrapper
struct CIBinding<Value> {
    private let get: () -> Value
    private let set: (Value) -> Void

    var projectedValue: CIBinding<Value> { self }
    var wrappedValue: Value {
        get { get() }
        nonmutating set { set(newValue) }
    }

    init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.get = get
        self.set = set
    }
    
    init<V>(_ base: CIBinding<V>) where Value == V? {
        self.init(get: { base.wrappedValue }, set: { base.wrappedValue = $0! })
    }

    init?(_ base: CIBinding<Value?>) {
        guard let value = base.wrappedValue else { return nil }
        self.init(get: { value }, set: { base.wrappedValue = $0 })
    }
    
    init<V>(_ base: CIBinding<V>) where Value == AnyHashable, V : Hashable {
        self.init(get: { base.wrappedValue }, set: { base.wrappedValue = $0.base as! V })
    }
}


extension CIBinding: Identifiable where Value: Identifiable {
    var id: Value.ID { wrappedValue.id }
}
