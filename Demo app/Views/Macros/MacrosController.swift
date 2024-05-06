import UIKit
import DemoMacro

// Menu > New > Package > Swift Macro > Create in existing project root folder
// Menu > Add Package Dependencies > Select Macro project > Choose target

class MacrosController: UIViewController {

    var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        
        XListView(views: [
            UI.label(text: "").also { self.label1 = $0 },
            
            UI.stackView(axis: .horizontal, spacing: 10, views: [
                UI.button("AAA", onTap: { [weak self] in
                    guard let self else { return }
                    self.showText("AAA")
                }),
                UI.button("BBB", onTap: {  [weak self] in
                    guard let self else { return }
                    self.showText("BBB")
                }),
            ]),
        ]).add(toParentView: self.view)
    }
    
    func showText(_ text: String?) {
        self.label1.text = text ?? "nil"
    }
    
}


fileprivate class UserObject {
    var name: String = "alex"
    var tag: String? = nil
    var age: Int = 12
    
    // Code below will be added by macros
    
    func _setValue(_ value: Any?, forKey key: String) {
        switch key {
        case "name":
            if let value = value as? String {
                name = value
            }
        case "tag":
            tag = value as? String // nullable
        case "age":
            if let value = value as? Int {
                age = value
            }
        default:
            break
        }
    }
    
    func _getValue(forKey key: String) -> Any? {
        switch key {
        case "name": return name
        case "tag": return tag
        case "age": return age
        default: return nil
        }
    }
}
