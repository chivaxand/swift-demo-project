import Foundation


extension NSObject {
    func pointerInt() -> Int {
        return unsafeBitCast(self, to: Int.self) // return Int(bitPattern: self)
    }
}

extension Equatable {
    /** client.also { $0.name = "123" } */
    @discardableResult @inlinable func also(_ block: (_ v: Self) throws -> Void ) rethrows -> Self {
        try block(self)
        return self
    }
    
    @inlinable func convert<T>(_ block: (_ v: Self) -> T ) -> T {
        return block(self)
    }
    
    @inlinable func takeIf(_ block: (_ v: Self) -> Bool ) -> Self? {
        return block(self) ? self : nil
    }
    
    func classToString() -> String {
        return NSStringFromClass(type(of: self as AnyObject))
    }
}

extension Swift.Optional {
    // let name = try nameOrNil.orThrow(ErrorResult("error"))
    @discardableResult func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }
    
    @discardableResult func orThrowError(_ message: String? = nil) throws -> Wrapped {
        guard let value = self else {
            throw NSError.with(message: message ?? "required value is null")
        }
        return value
    }
    
    // let name = client.ifNotNull { $0.name } ?? "None"
    func ifNotNil<T>(_ block: (_ v: Wrapped) -> T?) -> T? {
        if let self = self {
            return block(self)
        }
        return nil
    }
}
