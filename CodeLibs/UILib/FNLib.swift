import Foundation


enum FN {
    
     @discardableResult static func also<T>(_ object: T, _ block: (T) throws -> Void) rethrows -> T {
        try block(object)
        return object
    }

}
