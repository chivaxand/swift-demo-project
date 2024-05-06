import Foundation

class CustomEncoder: Encoder, SingleValueEncodingContainer{
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    var dataDict: [String: String] = [:]
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        let container = CustomKeyedEncodingContainer<Key>(encoder: self)
        return KeyedEncodingContainer(container)
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("Unimplemented")
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        return self
    }
    
    func encode<T>(_ value: T) throws where T: Encodable {
        try value.encode(to: self)
    }
    
    func encode(_ value: Encodable) throws -> String {
        try value.encode(to: self)
        return encodedString()
    }
    
    func encodeNil() throws {
        fatalError("Unimplemented")
    }
    
    func encodedString() -> String {
        return dataDict.map { "\($0.key)=\($0.value)" }.joined(separator: ",")
    }
}

fileprivate struct CustomKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {
    var codingPath: [CodingKey]
    private let encoder: CustomEncoder
    
    init(encoder: CustomEncoder) {
        self.encoder = encoder
        self.codingPath = encoder.codingPath
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
        encoder.codingPath.append(key)
        defer { encoder.codingPath.removeLast() }
        if let stringValue = value as? String {
            encoder.dataDict[key.stringValue] = stringValue
        } else if let intValue = value as? Int {
            encoder.dataDict[key.stringValue] = String(intValue)
        } else {
            throw EncodingError.invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: "Unsupported type"))
        }
    }
    
    func encodeNil(forKey key: Key) throws {
        fatalError("Unimplemented")
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError("Unimplemented")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        fatalError("Unimplemented")
    }
    
    func superEncoder() -> Encoder {
        return encoder
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        return encoder
    }
}
