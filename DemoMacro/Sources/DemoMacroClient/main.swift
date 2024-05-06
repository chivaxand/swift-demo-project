import DemoMacro

let result = #stringify(3 + /* test */ 7)

print("result: \(result)")


@KeyValueProperties
class SomeClass {
    var name: String
    var text: String?
    var index: Int
    let id: Int
    
    init(name: String, text: String? = nil, index: Int, id: Int) {
        self.name = name
        self.text = text
        self.index = index
        self.id = id
    }

}

let obj = SomeClass(name: "aa", text: "bb", index: 1, id: 2)
obj._setValue("new name", forKey: "name")
print(obj.name)
