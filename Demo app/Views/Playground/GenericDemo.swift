import Foundation

enum GenericDemo {
    
    static func genericTest() {
        
        protocol SomeProtocol<T> {
            associatedtype T
            func printValue()
            func getValue() -> T
        }
        
        class SomeClass<T>: SomeProtocol {
            let value: T
            init(value: T) {
                self.value = value
            }
            func printValue() {
                print("value: \(value)")
            }
            func getValue() -> T {
                return self.value
            }
        }
        
        class AnySomeClass {
            private let _printValue: () -> Void
            init<T>(_ someClass: SomeClass<T>) {
                _printValue = { someClass.printValue() }
            }
            func printValue() {
                _printValue()
            }
        }
        
        func processItem<T>(example: SomeClass<T>) {
            example.printValue()
            let value = example.getValue()
            print(value)
        }
        
        let listA: [SomeClass<Any>] = [
            SomeClass(value: "Hello"),
            SomeClass(value: 42),
        ]
        
        for item in listA {
            let value = item.getValue()
            print(">>> listA: item type: \(type(of: item))") // ExampleClass<Any>
            print(">>> listA: value type: \(type(of: value))") // String, Int
            processItem(example: item)
        }
        
        let listB: [Any] = listA
        
        for item in listB {
            print(">>> listB: item type: \(type(of: item))") // ExampleClass<Any>
            if let item = item as? SomeClass<Any> {
                processItem(example: item) // called
            }
            if let item = item as? SomeClass<String> {
                let _ = item.getValue() // not called
            }
            if let item = item as? (any SomeProtocol) {
                let _ = item.getValue() // called
            }
        }
        
        let listC: [Any] = [
            SomeClass(value: "Hello"),
            AnySomeClass(SomeClass(value: 42)),
        ]
        
        for item in listC {
            print(">>> listC: item type: \(type(of: item))") // ExampleClass<String>, ExampleClass<Int>
            if let item = item as? SomeClass<Any> {
                processItem(example: item) // not called
            }
            if let item = item as? SomeClass<String> {
                processItem(example: item) // called
            }
            if let item = item as? (any SomeProtocol) {
                let _ = item.getValue() // called
            }
            if let item = item as? AnySomeClass {
                item.printValue() // called only for wrapped class
            }
        }
    }
    
}
