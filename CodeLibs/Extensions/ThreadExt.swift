import Foundation


enum ThreadSafe {
    private static let lock = NSRecursiveLock()
    private static let queue = DispatchQueue(label: "com.threadSafeQueue", attributes: .concurrent)

    static func lock<T>(_ block: () throws -> T) rethrows -> T {
        lock.lock()
        defer { lock.unlock() }
        return try block()
    }
    
    static func asyncLock(_ block: @escaping () -> Void) {
        queue.async {
            self.lock { block() }
        }
    }
}

