import Foundation

extension Swift.Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    func contains<T : Equatable>(_ value: T) -> Bool {
        return self?.contains(value) ?? false
    }
}

extension Swift.Collection {
    func contains<T : Equatable>(_ value: T) -> Bool {
        if Element.self is T {
            for elem in self {
                if elem as? T == value {
                    return true
                }
            }
        }
        return false
    }
}

extension Swift.Array {
    @inlinable func asTypedArray<T>(_ type: T.Type) -> [T] {
        return (self as NSArray).map { $0 as! T }
    }
}

extension Sequence {
    /* let result = ([1,2,3].associateBy { String($0 * 100) } as [String:Int]) */
    public func associateBy<T, K: Hashable>(_ keyBlock: (T) -> K?) -> [K:T] where T == Iterator.Element {
        var dict: [K:T] = [:]
        for element in self {
            if let key = keyBlock(element) {
                dict[key] = element
            }
        }
        return dict
    }
    
    /* let result = [1,2,3].associate { ($0 * 100, String($0)) } */
    public func associate<T, K: Hashable, V>(_ keyValueBlock: (T) -> (K?,V?)) -> [K:V] where T == Iterator.Element {
        var dict: [K:V] = [:]
        for element in self {
            let (key, value) = keyValueBlock(element)
            if let key = key {
                dict[key] = value
            }
        }
        return dict
    }
    
    @inlinable public func uniqueItems<T: Hashable>() -> Set<Element> where Element == T {
        return Set(self)
    }
    
    public func mapUnique<T, K>(_ valueBlock: (T) -> K?) -> Set<K> where T == Iterator.Element, K: Hashable {
        var result = Set<K>()
        for element in self {
            if let value = valueBlock(element) {
                result.insert(value)
            }
        }
        return result
    }
    
    public func uniqueBy<T, K>(_ keyBlock: (T) -> K?) -> [T] where T == Iterator.Element, K: Hashable {
        var keys = Set<K>()
        var result = Array<T>()
        for element in self {
            if let key = keyBlock(element) {
                if !keys.contains(key) {
                    keys.insert(key)
                    result.append(element)
                }
            }
        }
        return result
    }
    
    func associate<T: Hashable>(by keyPath: KeyPath<Element, T?>) -> [T?: [Element]] {
        var dictionary: [T?: [Element]] = [:]
        for element in self {
            let key = element[keyPath: keyPath]
            dictionary[key, default: []].append(element)
        }
        return dictionary
    }
    
    func map<T: Hashable>(by keyPath: KeyPath<Element, T?>) -> [T?: [Element]] {
        var groups: [T?: [Element]] = [:]
        for element in self {
            let key = element[keyPath: keyPath]
            if var group = groups[key] {
                group.append(element)
                groups[key] = group
            } else {
                groups[key] = [element]
            }
        }
        return groups
    }
    
    func chained<T: Hashable>(by keyPath: KeyPath<Element, T?>) -> [[Element]] {
        return map(by: keyPath).map { $0.value }
    }
    
}

