import UIKit

class KeychainController: UIViewController {
    
    var label1: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        
        let keychainKey1 = "test_key1"
        
        XListView(views: [
            UI.label(text: "").also {
                self.label1 = $0
                self.label1.text = readKey(keychainKey1)
            },
            
            UI.stackView(axis: .horizontal, spacing: 10, views: [
                UI.button("Change value", onTap: { [weak self] in
                    guard let self else { return }
                    let value = String.random(count: 10)
                    do {
                        try KeychainHelper.save(data: value.data(using: .utf8)!, forKey: keychainKey1)
                    } catch {
                        print("Error: \(error)")
                    }
                    self.label1.text = readKey(keychainKey1)
                }),
                UI.button("Delete value", onTap: {  [weak self] in
                    guard let self else { return }
                    do {
                        try KeychainHelper.delete(forKey: keychainKey1)
                    } catch {
                        print("Error: \(error)")
                    }
                    self.label1.text = readKey(keychainKey1)
                }),
            ]),
        ]).add(toParentView: self.view)
        
    }
    
    func readKey(_ key: String) -> String {
        do {
            let data = try KeychainHelper.load(forKey: key)
            let string = data.ifNotNil { String(data: $0, encoding: .utf8) } ?? "nil"
            return string
        } catch {
            print("Error: \(error)")
        }
        return "error"
    }
}
