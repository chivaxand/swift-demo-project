import Foundation

// https://github.com/apple/swift/blob/main/stdlib/public/core/ReflectionMirror.swift

protocol CIKeyValueCoding { }

extension CIKeyValueCoding {
    
    public mutating func setValue(_ value: Any?, forKey key: String) {
        let mirror = Mirror(reflecting: self)
        guard let displayStyle = mirror.displayStyle
                , displayStyle == .class || displayStyle == .struct
        else {
            return
        }
        
        let type = type(of: self)
        let count = swift_reflectionMirror_recursiveCount(type)
        for i in 0..<count {
            var field = FieldReflectionMetadata()
            let childType = swift_reflectionMirror_recursiveChildMetadata(type, index: i, fieldMetadata: &field)
            defer { field.freeFunc?(field.name) }
            guard let name = field.name.flatMap({ String(validatingUTF8: $0) }),
                  name == key
            else {
                continue
            }
            
            let clildOffset = swift_reflectionMirror_recursiveChildOffset(type, index: i)
            
            try? self.withPointer(displayStyle: displayStyle) { pointer in
                let valuePointer = pointer.advanced(by: clildOffset)
                let container = ProtocolTypeContainer(type: childType)
                return container.accessors.set(value: value, pointer: valuePointer)
            }
            break
        }
    }
    
    private mutating func withPointer<Result>(displayStyle: Mirror.DisplayStyle,
                                              _ body: (UnsafeMutableRawPointer) throws -> Result) throws -> Result {
        switch displayStyle {
        case .struct:
            return try withUnsafePointer(to: &self) {
                let pointer = UnsafeMutableRawPointer(mutating: $0)
                return try body(pointer)
            }
        case .class:
            return try withUnsafePointer(to: &self) {
                try $0.withMemoryRebound(to: UnsafeMutableRawPointer.self, capacity: 1) {
                    return try body($0.pointee)
                }
            }
        default:
            fatalError("Unsupported type")
        }
    }
}


fileprivate typealias NameFreeFunc = @convention(c) (UnsafePointer<CChar>?) -> Void

fileprivate struct FieldReflectionMetadata {
    let name: UnsafePointer<CChar>? = nil
    let freeFunc: NameFreeFunc? = nil
    let isStrong: Bool = false
    let isVar: Bool = false
}

@_silgen_name("swift_reflectionMirror_recursiveCount")
fileprivate func swift_reflectionMirror_recursiveCount(_: Any.Type) -> Int

@_silgen_name("swift_reflectionMirror_recursiveChildMetadata")
fileprivate func swift_reflectionMirror_recursiveChildMetadata(
    _: Any.Type
    , index: Int
    , fieldMetadata: UnsafeMutablePointer<FieldReflectionMetadata>
) -> Any.Type

@_silgen_name("swift_reflectionMirror_recursiveChildOffset")
fileprivate func swift_reflectionMirror_recursiveChildOffset(_: Any.Type, index: Int) -> Int

fileprivate protocol Accessors { }
fileprivate extension Accessors {
    static func set(value: Any?, pointer: UnsafeMutableRawPointer) {
        if let value = value as? Self {
            pointer.assumingMemoryBound(to: self).pointee = value
        }
    }
}

fileprivate struct ProtocolTypeContainer {
    let type: Any.Type
    let witnessTable = 0
    var accessors: Accessors.Type { unsafeBitCast(self, to: Accessors.Type.self) }
}
