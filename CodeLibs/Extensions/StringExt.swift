import Foundation


extension StringProtocol {
    // let char = str[5]
    subscript(_ offset: Int) -> Element {
        self[index(startIndex, offsetBy: offset)]
    }
    
    // let sub = str[2..<5]
    subscript(_ range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(startIndex, offsetBy: range.count)
        return self[startIndex..<endIndex]
    }
    
    // let sub = str[2...5]
    subscript(_ range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        let endIndex = index(startIndex, offsetBy: range.count)
        return self[startIndex...endIndex]
    }
    
    // str[..<5]
    subscript(_ range: PartialRangeThrough<Int>) -> SubSequence {
        let endIndex = index(startIndex, offsetBy: range.upperBound)
        return self[startIndex...endIndex]
    }
    
    // str[..<5]
    subscript(_ range: PartialRangeUpTo<Int>) -> SubSequence {
        let endIndex = index(startIndex, offsetBy: range.upperBound)
        return self[startIndex..<endIndex]
    }
    
    // str[5...]
    subscript(_ range: PartialRangeFrom<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex...]
    }
}


extension Swift.Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    var orEmpty: String {
        return self ?? ""
    }
}


extension String {
    var parseJSON: Any? {
        guard let data = self.data(using: .utf8), data.count > 0 else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: [])
    }
    
    var parseJSONtoDict: [AnyHashable : Any]? {
        return parseJSON as? [AnyHashable : Any]
    }
    
    var parseJSONtoArray: [Any]? {
        return parseJSON as? [Any]
    }
    
    var notEmptyOrNil: String? {
        return self.isEmpty ? nil : self
    }
    
    var parseInt64: Int64 {
        return Int64(self) ?? 0
    }
    
    var parseUInt64: UInt64 {
        return UInt64(self) ?? 0
    }
    
    var toNSString: NSString {
        return self as NSString
    }
    
    static func random(count: Int, characters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789") -> String {
        var randomString = ""
        for _ in 0..<count {
            let randomIndex = Int.random(in: 0..<characters.count)
            let character = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            randomString.append(character)
        }
        return randomString
    }
    
}
