import UIKit

class EncoderDecoderController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        
        XListView(views: [
            UI.stackView(axis: .horizontal, spacing: 10, views: [
                UI.button("Custom encode", onTap: { [weak self] in
                    self?.customEncode()
                }),
                UI.button("Custom decode", onTap: {  [weak self] in
                    self?.customDecode()
                }),
            ]),
            
            UI.stackView(axis: .horizontal, spacing: 10, views: [
                UI.button("Encode to JSON", onTap: { [weak self] in
                    self?.encodeToJson()
                }),
                UI.button("Decode from JSON", onTap: {  [weak self] in
                    self?.decodeFromJson()
                }),
            ]),
            
            UI.button("JSON inheritance", onTap: { [weak self] in
                self?.jsonWithInheritance()
            }),
            
            UI.button("JSON inheritance encode (custom)", onTap: { [weak self] in
                self?.jsonWithInheritanceCustomEncode()
            }),
            UI.button("JSON inheritance decode (custom)", onTap: { [weak self] in
                self?.jsonWithInheritanceCustomDecode()
            }),
            
        ]).add(toParentView: self.view)
    }
    
    func customEncode() {
        do {
            let object = CustomData(key1: "value1", key2: 42)
            let item = try CustomEncoder().encode(object)
            print("Encoded: \(item)")
        } catch {
            print("Encoding error: \(error)")
        }
    }
    
    func customDecode() {
        let dataString = "key1=value1,key2=42"
        do {
            let object = try CustomData(from: CustomDecoder(dataString: dataString))
            //let object = try CustomDecoder(dataString: dataString).decode(CustomData.self)
            print("Decoded: \(object)")
        } catch {
            print("Encoding error: \(error)")
        }
    }
    
    func encodeToJson() {
        let object = CustomData(key1: "value1", key2: 42)
        do {
            let jsonData = try JSONEncoder().encode(object)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("Encoded JSON: \(jsonString)")
            }
        } catch {
            print("JSON encoding error: \(error)")
        }
    }
    
    func decodeFromJson() {
        let jsonString = """
        {
            "key1": "value1",
            "key2": 42
        }
        """
        let jsonData = Data(jsonString.utf8)
        do {
            let object = try JSONDecoder().decode(CustomData.self, from: jsonData)
            print("Decoded object: \(object)")
        } catch {
            print("JSON decoding error: \(error)")
        }
    }
    
    func jsonWithInheritance() {
        let object = DefaultCodable.UserObject(id: 1, name: "bob", age: 34)
        do {
            if let json = String(data: try JSONEncoder().encode(object), encoding: .utf8) {
                print("JSON: \(json)")
            }
        } catch {
            print("JSON encoding error: \(error)")
        }
    }
    
    func jsonWithInheritanceCustomEncode() {
        let object = CustomCodable.UserObject()
        do {
            if let json = String(data: try JSONEncoder().encode(object), encoding: .utf8) {
                print("JSON: \(json)")
            }
        } catch {
            print("JSON encoding error: \(error)")
        }
    }
    
    func jsonWithInheritanceCustomDecode() {
        let jsonString = #"{"id":111, "user_name":"AAAAA", "height":22.33, "tag":null, "age":55, "list":[111, 222]}"#
        let jsonData = Data(jsonString.utf8)
        do {
            let object = try JSONDecoder().decode(CustomCodable.UserObject.self, from: jsonData)
            print("Decoded object: \(object)")
        } catch {
            print("JSON decoding error: \(error)")
        }
    }
}


fileprivate struct CustomData: Decodable, Encodable {
    let key1: String
    let key2: Int
    
    /*
    // Automatically generated
    
    init(key1: String, key2: Int) {
        self.key1 = key1
        self.key2 = key2
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key1, forKey: .key1)
        try container.encode(key2, forKey: .key2)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key1 = try container.decode(String.self, forKey: .key1)
        key2 = try container.decode(Int.self, forKey: .key2)
    }
    
    private enum CodingKeys: String, CodingKey {
        case key1
        case key2
    } // */
}

fileprivate enum DefaultCodable {
    
    class BaseObject: Codable {
        let id: Int
        
        enum CodingKeys: String, CodingKey {
            case id
        }
        init(id: Int) {
            self.id = id
        }
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
        }
        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.id, forKey: .id)
        }
    }

    class UserObject: BaseObject {
        let name: String
        let age: Int
        
        enum CodingKeys: String, CodingKey {
            case name, age
        }
        init(id: Int, name: String, age: Int) {
            self.name = name
            self.age = age
            super.init(id: id)
        }
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            age = try container.decode(Int.self, forKey: .age)
            try super.init(from: decoder)
        }
        override func encode(to encoder: any Encoder) throws {
            try super.encode(to: encoder)
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try container.encode(age, forKey: .age)
        }
    }
}


fileprivate enum CustomCodable {
    class BaseObject: CICodable {
        var id: Int = 0
        required init() {}
    }

    class UserObject: BaseObject, CustomStringConvertible {
        @CIPropertyInfo(name: "user_name")
        var name: String = "alex"
        @CIPropertyInfo
        var tag: String? = nil
        var age: Int = 12
        var height: Double = 1.76
        var list: [Int] = [1, 2, 3]
        
        var description: String {
            return "id:\(id), name: \(name), tag: \(tag ?? "nil"), age:\(age), height: \(height), list: \(list)"
        }
    }
    
}


