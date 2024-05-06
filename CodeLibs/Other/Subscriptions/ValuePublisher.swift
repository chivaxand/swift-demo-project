import Foundation

class ValuePublisher<Value> {
    private let notifyQueue: DispatchQueue?
    private let closures = ClosuresList<(Value) -> Void>()
    private var _value: Value
    var value: Value {
        get { _value }
        set {
            _value = newValue
            send(newValue)
        }
    }
    
    init(_ value: Value, queue: DispatchQueue? = DispatchQueue.main) {
        self._value = value
        self.notifyQueue = queue
    }
    
    func subscribe(notify: Bool = true, _ closure: @escaping (Value) -> Void) -> CIAnyCancellable {
        let closureWrapper = self.closures.add(closure)
        if (notify) {
            closure(self._value)
        }
        return CIAnyCancellable { [weak self] in
            guard let self else { return }
            self.closures.remove(closureWrapper)
        }
    }
    
    func send(_ value: Value) {
        if let notifyQueue = self.notifyQueue {
            notifyQueue.async { [weak self] in
                self?.notifySubscribers(value)
            }
        } else {
            self.notifySubscribers(value)
        }
    }
    
    private func notifySubscribers(_ value: Value) {
        let allClosures = self.closures.allClosures
        self._value = value
        for closure in allClosures {
            closure.closure(value)
        }
    }
}


@propertyWrapper
class PublishedValue<Type> {
    private let publisher: ValuePublisher<Type>

    var wrappedValue: Type {
        get { publisher.value }
        set { publisher.send(newValue) }
    }

    var projectedValue: ValuePublisher<Type> {
        return publisher
    }

    init(wrappedValue initialValue: Type, notifyQueue: DispatchQueue = DispatchQueue.main) {
        self.publisher = ValuePublisher(initialValue, queue: notifyQueue)
    }
}
