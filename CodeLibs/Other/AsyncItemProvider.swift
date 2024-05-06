import Foundation

fileprivate let asyncItemProviderQueue = DispatchQueue(label: "com.app.AsyncItemProvider")

class AsyncItemProvider<T>: IteratorProtocol, Sequence {
    private var items = [T?]()
    private let semaphore = DispatchSemaphore(value: 0)
    private let queue = asyncItemProviderQueue
    
    func makeIterator() -> AsyncItemProvider<T> {
        return self
    }
    
    func sendNext(_ item: T?) {
        queue.async {
            self.items.append(item)
            self.semaphore.signal()
        }
    }
    
    func next() -> T? {
        semaphore.wait()
        var result: T?
        
        queue.sync {
            if !self.items.isEmpty {
                result = self.items.removeFirst()
            }
        }
        
        return result
    }
}
