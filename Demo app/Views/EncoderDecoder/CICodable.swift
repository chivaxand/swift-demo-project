import Foundation

protocol CICodable: Codable {
    init()
    func decode(from decoder: Decoder) throws
}

extension CICodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CICodingKey.self)
        var mirror: Mirror? = Mirror(reflecting: self)
        
        // iterate over all parent classes
        repeat {
            guard let children = mirror?.children else { break }
            
            for child in children {
                let value = child.value
                let propertyName = child.label ?? ""
                
                // property wrapper
                if let wrapper = value as? (any CIPropertyEncodable) { // CIPropertyAttr<Any>
                    let name = String(propertyName.dropFirst())
                    try wrapper.encodeValue(container: &container, propertyName: name)
                    continue
                }
                
                if let encodableValue = value as? Encodable {
                    try container.encodeIfPresent(encodableValue, forKey: CICodingKey(key: propertyName))
                }
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
    }
}


extension CICodable {
    
    init(from decoder: Decoder) throws {
        self.init()
        try decode(from: decoder)
    }
    
    func decode(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CICodingKey.self)
        var mirror: Mirror? = Mirror(reflecting: self)

        // iterate over all parent classes
        repeat {
            guard let children = mirror?.children else { break }
            
            for child in children {
                let value = child.value
                let propertyName = child.label ?? ""
                
                // property wrapper
                if let wrapper = value as? (any CIPropertyDecodable) { // CIPropertyAttr<Any>
                    let name = String(propertyName.dropFirst())
                    try wrapper.decodeValue(container: container, propertyName: name)
                    continue
                }
                
                // TODO: apply decoded values to object
                if let decodableValue = child.value as? Decodable {
                    // self.setValue(value, forKey: propertyName)
                    print("Not decoded: `\(propertyName)`")
                    switch decodableValue {
                    case _ as Int:
                        if let value = try container.decodeIfPresent(Int.self, forKey: CICodingKey(key: propertyName)) {
                            print("Int: \(value)")
                        }
                    case _ as String:
                        if let value = try container.decodeIfPresent(Int.self, forKey: CICodingKey(key: propertyName)) {
                            print("String: \(value)")
                        }
                    default:
                        break
                    }
                }
            }
            mirror = mirror?.superclassMirror
        } while mirror != nil
    }
}


fileprivate struct CICodingKey: CodingKey {
    var stringValue: String
    var intValue: Int?

    init(key: String) {
        stringValue = key
    }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        self.intValue = intValue
        self.stringValue = String(intValue)
    }
}


@propertyWrapper
class CIPropertyInfo<Value> {
    var name: String?
    private var _value: Value?
    
    private func _wrappedValue<Nullable>(_ type: Nullable.Type) -> Nullable? where Nullable: ExpressibleByNilLiteral {
        return _value as? Nullable
    }
    
    private func _wrappedValue<Nullable>(_ type: Nullable.Type) -> Nullable {
        return _value as! Nullable
    }
    
    var wrappedValue: Value {
        get { return _wrappedValue(Value.self) }
        set { _value = newValue }
    }
    
    init(wrappedValue value: Value, name: String = "") {
        self._value = value
        self.name = name
    }
}


fileprivate protocol CIPropertyEncodable {
    func encodeValue(container: inout KeyedEncodingContainer<CICodingKey>, propertyName: String) throws
}

extension CIPropertyInfo: CIPropertyEncodable where Value: Encodable {
    fileprivate func encodeValue(container: inout KeyedEncodingContainer<CICodingKey>, propertyName: String) throws {
        let key = if let name = self.name, !name.isEmpty { name } else { propertyName }
        try container.encodeIfPresent(self.wrappedValue, forKey: CICodingKey(key: key))
    }
}


fileprivate protocol CIPropertyDecodable {
    func decodeValue(container: KeyedDecodingContainer<CICodingKey>, propertyName: String) throws
}

extension CIPropertyInfo: CIPropertyDecodable where Value: Decodable {
    fileprivate func decodeValue(container: KeyedDecodingContainer<CICodingKey>, propertyName: String) throws {
        let key = if let name = self.name, !name.isEmpty { name } else { propertyName }
        let value = try container.decodeIfPresent(Value.self, forKey: CICodingKey(key: key))
        self._value = value
    }
}
