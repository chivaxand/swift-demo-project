import Foundation

protocol CIObservable {
    associatedtype Observer
    func addObserver(_ observer: Observer)
    func removeObserver(_ observer: Observer)
}

protocol CIObservableImplemented: CIObservable {
    var observers: ObserversNotifier<Observer> { get set }
}

extension CIObservableImplemented {
    func addObserver(_ observer: Observer) {
        self.observers.addObserver(observer)
    }
    func removeObserver(_ observer: Observer) {
        self.observers.removeObserver(observer)
    }
}

class ObserversNotifier<Observer> {
    private var observers = Set<WeakHolder<AnyObject>>()
    private let lock = NSLock()
    private var notifyQueue: DispatchQueue?
    
    func addObserver(_ observer: Observer) {
        lock.lock()
        defer { lock.unlock() }
        removeNilObservers()
        observers.insert(WeakHolder(observer as AnyObject))
    }

    func removeObserver(_ observer: Observer) {
        lock.lock()
        defer { lock.unlock() }
        observers.remove(WeakHolder(observer as AnyObject))
    }

    func notifyEachObserver(_ block: @escaping (Observer) -> Void) {
        if let queue = self.notifyQueue {
            queue.async {
                self._notifyEachObserver(block)
            }
        } else {
            self._notifyEachObserver(block)
        }
    }
    
    func notifyObservers(_ block: @escaping ([Observer]) -> Void) {
        if let queue = self.notifyQueue {
            queue.async {
                self._notifyObservers(block)
            }
        } else {
            self._notifyObservers(block)
        }
    }
    
    private func _notifyObservers(_ block: @escaping ([Observer]) -> Void) {
        self.lock.lock()
        self.removeNilObservers()
        let observers = self.observers.compactMap { $0.object as? Observer }
        self.lock.unlock()
        
        block(observers)
    }
    
    private func _notifyEachObserver(_ block: @escaping (Observer) -> Void) {
        self.lock.lock()
        self.removeNilObservers()
        let observers = self.observers.compactMap { $0.object as? Observer }
        self.lock.unlock()
        
        observers.forEach { observer in
            block(observer)
        }
    }
    
    private func removeNilObservers() {
        if (self.observers.allSatisfy { $0.object != nil }) {
            return
        }
        self.observers = self.observers.filter { $0.object != nil }
    }
    
    struct WeakHolder<Object: AnyObject>: Hashable {
        weak var object: Object?
        init(_ object: Object) {
            self.object = object
        }
        
        static func == (lhs: WeakHolder, rhs: WeakHolder) -> Bool {
            return lhs.object === rhs.object
        }

        func hash(into hasher: inout Hasher) {
            if let object = self.object {
                hasher.combine(ObjectIdentifier(object))
            }
        }
    }
}

