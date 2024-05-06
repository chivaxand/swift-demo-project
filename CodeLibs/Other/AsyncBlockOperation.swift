import Foundation

class AsyncBlockOperation: Operation {
    typealias Task = (AsyncBlockOperation) -> Void
    private let asyncTask: Task
    private var _isExecuting = false
    private var _isFinished = false
    
    override var isExecuting: Bool { self._isExecuting }
    override var isFinished: Bool { self._isFinished }
    override var isAsynchronous: Bool { true }
    
    init(_ asyncTask: @escaping Task) {
        self.asyncTask = asyncTask
        super.init()
    }
    
    override func start() {
        if isCancelled {
            _isFinished = true
            return
        }
        
        willChangeValue(forKey: "isExecuting")
        _isExecuting = true
        main()
        didChangeValue(forKey: "isExecuting")
    }
    
    override func main() {
        self.asyncTask(self)
    }
    
    func finish() {
        willChangeValue(forKey: "isExecuting")
        willChangeValue(forKey: "isFinished")
        _isExecuting = false
        _isFinished = true
        didChangeValue(forKey: "isExecuting")
        didChangeValue(forKey: "isFinished")
    }
    
}

