import Foundation


class CustomDecoder: Decoder {
    
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    let singleValueDecoder: SingleValueDecoder
    
    let dataDict: [String: String]
    
    init(dataString: String) {
        self.dataDict = CustomDecoder.parseDataString(dataString: dataString)
        self.singleValueDecoder = SingleValueDecoder(dataDict: self.dataDict, codingPath: self.codingPath)
    }
    
    private static func parseDataString(dataString: String) -> [String: String] {
        var dataDict: [String: String] = [:]
        
        let pairs = dataString.split(separator: ",")
        for pair in pairs {
            let keyValue = pair.split(separator: "=")
            if keyValue.count == 2 {
                let key = String(keyValue[0])
                let value = String(keyValue[1])
                dataDict[key] = value
            }
        }
        
        return dataDict
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        let container = CustomKeyedDecodingContainer<Key>(decoder: self)
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("Unimplemented")
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self.singleValueDecoder
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try T(from: self)
    }
    
    class SingleValueDecoder: SingleValueDecodingContainer {
        
        var dataDict: [String: String]
        var codingPath: [CodingKey] = []
        
        init(dataDict: [String : String], codingPath: [CodingKey]) {
            self.dataDict = dataDict
            self.codingPath = codingPath
        }
        
        func decodeNil() -> Bool {
            return false
        }
        
        func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
            guard let value = dataDict[codingPath.last?.stringValue ?? ""] else {
                throw DecodingError.keyNotFound(codingPath.last!, DecodingError.Context(codingPath: codingPath, debugDescription: "Key not found"))
            }
            
            return try castValue(value, to: type)
        }
        
        private func castValue<T>(_ value: String, to type: T.Type) throws -> T where T: Decodable {
            if type == String.self {
                return value as! T
            } else if type == Int.self {
                guard let intValue = Int(value) else {
                    throw DecodingError.dataCorruptedError(in: self, debugDescription: "Invalid integer format")
                }
                return intValue as! T
            } else {
                throw DecodingError.typeMismatch(type, DecodingError.Context(codingPath: codingPath, debugDescription: "Unsupported type"))
            }
        }
    }
}

fileprivate struct CustomKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol {
    
    var codingPath: [CodingKey]
    private let decoder: CustomDecoder
    
    init(decoder: CustomDecoder) {
        self.decoder = decoder
        self.codingPath = decoder.codingPath
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        decoder.singleValueDecoder.codingPath.append(key)
        defer { decoder.singleValueDecoder.codingPath.removeLast() }
        return try decoder.singleValueDecoder.decode(type)
    }
    
    var allKeys: [Key] {
        return decoder.dataDict.keys.compactMap { Key(stringValue: $0) }
    }
    
    func contains(_ key: Key) -> Bool {
        return decoder.dataDict.keys.contains(key.stringValue)
    }
    
    func superDecoder() throws -> Decoder {
        return decoder
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        return decoder
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        fatalError("Unimplemented")
    }
    
    func decodeIfPresent<T>(_ type: T.Type, forKey key: Key) throws -> T? where T : Decodable {
        fatalError("Unimplemented")
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        fatalError("Unimplemented")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        fatalError("Unimplemented")
    }
}
