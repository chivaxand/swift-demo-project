import UIKit

class ThreadQueueController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        XListView(views: [
            UI.stackView(axis: .horizontal, spacing: 10, views: [
                UI.button("Test lock", onTap: { [weak self] in
                    self?.testThreadSafeLock()
                }),
                UI.button("Test async queue", onTap: { [weak self] in
                    self?.testThreadSafeSyncQueue()
                }),
            ]),
            
            UI.button("Test `var` property copying", onTap: { [weak self] in
                self?.testVarPropertyCopying()
            }),
            
            UI.button("Async Block Operations", onTap: { [weak self] in
                self?.asyncBlockOperations()
            }),

        ]).add(toParentView: self.view)
    }
    
    func testThreadSafeLock() {
        var counter = 0
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.concurrentQueue", attributes: .concurrent)
        for _ in 0..<10 {
            group.enter()
            queue.async {
                print("Before: \(counter)")
                ThreadSafe.lock {
                    print("Inside: \(counter)")
                    counter += 1
                    Thread.sleep(forTimeInterval: 0.01)
                }
                group.leave()
            }
        }
        group.notify(queue: .main) {
            print("finished")
        }
        group.wait()
        print("Counter value: \(counter)")
    }
    
    func testThreadSafeSyncQueue() {
        var counter = 0
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.concurrentQueue", attributes: .concurrent)
        let syncQueue = DispatchQueue(label:"com.syncQueue")
        for _ in 0..<10 {
            group.enter()
            queue.async {
                print("Before: \(counter)")
                syncQueue.sync {
                    print("Inside: \(counter)")
                    counter += 1
                    Thread.sleep(forTimeInterval: 0.01)
                }
                group.leave()
            }
        }
        group.wait()
        print("Counter value: \(counter)")
    }
    
    func testVarPropertyCopying() {
        let queue1 = DispatchQueue(label: "Thread1")
        let queue2 = DispatchQueue(label: "Thread2")
        
        class ItemsList {
            var items: [Int]
            init(_ items: [Int]) {
                self.items = items
            }
        }
        
        // Array, Dictionary, String are all value types
        let list = ItemsList([1, 2, 3])
        var items = list.items // `items` is mutable copy of `list.items`
        items.append(444)
        list.items.append(555)
        print("list.items: \(list.items)")
        print("     items: \(items)")
        
        var items1 = [1, 2, 3]
        var items2 = items1 // `items2` is mutable copy of `items1`
        
        queue1.async {
            usleep(1 * 1000_000)
            items2.append(444)
            print("1: items1: \(items1)")
            print("1: items2: \(items2)")
        }

        queue2.async {
            usleep(UInt32(0.5 * 1000_000))
            changeArray(&items1)
            print("2: items1: \(items1)")
            print("2: items2: \(items2)")
        }
        
        func changeArray(_ items: inout [Int]) {
            items.append(555)
        }
    }
    
    func asyncBlockOperations() {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 10
        queue.addOperation {
            usleep(UInt32(0.1 * 1000_000))
            print("000")
        }
        queue.addOperation(AsyncBlockOperation { operation in
            DispatchQueue.global().async {
                usleep(UInt32(0.2 * 1000_000))
                print("111")
                operation.finish()
            }
        })
        let operation2 = AsyncBlockOperation { operation in
            DispatchQueue.global().async {
                usleep(UInt32(0.4 * 1000_000))
                print("222")
                operation.finish()
            }
        }
        let operation3 = BlockOperation {
            usleep(UInt32(0.6 * 1000_000))
            print("333")
        }
        
        queue.addOperations([operation2, operation3], waitUntilFinished: false)
        
        queue.addBarrierBlock {
            print("finished 1")
        }
        DispatchQueue.global().async {
            queue.waitUntilAllOperationsAreFinished()
            print("finished 2")
        }

    }
}
