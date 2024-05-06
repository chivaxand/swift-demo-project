import UIKit

/*
 let dep = Dependencies()
 dep.register(type: SomeClass.self) { dependencies in
     return SomeClass()
 }
 
 dep.register(type: OtherClass.self) { dependencies in
     return OtherClass(other: dependencies.resolve(type: SomeClass.self)!)
 }
 
 let b = dep.resolve<OtherClass>(type: OtherClass.self)
 let a = dep.resolve<SomeClass>(type: SomeClass.self)
 */
@objcMembers
public final class Dependencies: NSObject {
    
    typealias FactoryBlock = (_ dependencies: Dependencies) -> AnyObject
    typealias FactoryBlockT<T: AnyObject> = (_ dependencies: Dependencies) -> T
    
    private let lock = NSRecursiveLock()
    private var dependencies = [String: Dependency]()
    private var resolvingDependencies = [String]()

    private class Dependency {
        let name: String
        let factory: FactoryBlock
        var instance: AnyObject? = nil
        
        init(name: String, factory: @escaping FactoryBlock) {
            self.name = name
            self.factory = factory
        }
    }
    
    override init() {}
    
    func register(type: AnyClass, factory: @escaping FactoryBlock) {
        let dependency = Dependency(name: getNameByClass(type), factory: factory)
        dependencies[dependency.name] = dependency
    }
    
    func register(name: String, factory: @escaping FactoryBlock) {
        let dependency = Dependency(name: name, factory: factory)
        dependencies[dependency.name] = dependency
    }
    
    func register<T: AnyObject>(type: T.Type, factory: @escaping FactoryBlockT<T>) {
        register(name: getNameByClass(type), factory: factory)
    }
    
    func resolve<T: AnyObject>(_ type: T.Type) -> T? {
        return resolve(name: getNameByClass(type)) as? T
    }
    
    func resolve(name: String) -> AnyObject? {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        if resolvingDependencies.contains(name) {
            fatalError("Error: Recursive dependency resolution detected for `\(name)` in sequence: \(resolvingDependencies)")
        }
        
        if let dependency = dependencies[name] {
            if let instance = dependency.instance {
                return instance
            }
            
            resolvingDependencies.append(name)
            let instance = autoreleasepool {
                dependency.factory(self)
            }
            resolvingDependencies.removeLast()
            
            dependency.instance = instance
            return instance
        }
        return nil
    }

    func resolveAll() {
        lock.lock()
        defer {
            lock.unlock()
        }
        
        for (_, dependency) in dependencies {
            if dependency.instance == nil {
                autoreleasepool {
                    dependency.instance = dependency.factory(self)
                }
            }
        }
    }
    
    func remove(type: AnyClass) {
        self.remove(name: getNameByClass(type))
    }
    
    func remove(name: String) {
        dependencies.removeValue(forKey: name)
    }
    
    func getNameByClass(_ classType: AnyObject) -> String {
        return NSStringFromClass(type(of: classType))
    }
    
}
