import Foundation

class ClosuresList<T> {
    private var closures = Set<ClosureWrapper>()
    private let lock = NSLock()
    
    class ClosureWrapper: Hashable {
        let id: UUID = UUID()
        let closure: T
        init(closure: T) {
            self.closure = closure
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        static func == (lhs: ClosureWrapper, rhs: ClosureWrapper) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    var allClosures: Set<ClosureWrapper> {
        lock.lock()
        let copy = closures
        lock.unlock()
        return copy
    }
    
    func add(_ block: T) -> ClosureWrapper {
        let wrapper = ClosureWrapper(closure: block)
        lock.lock()
        closures.insert(wrapper)
        lock.unlock()
        return wrapper
    }
    
    func remove(_ wrapper: ClosureWrapper) {
        lock.lock()
        closures.remove(wrapper)
        lock.unlock()
    }
}
